import re

from PySide6.QtCore import (
    QAbstractListModel,
    QAbstractItemModel,
    QModelIndex,
    Qt,
    Slot,
)
from PySide6.QtQml import QJSValue

from data import Question, Category, Quiz
import roles


class CategoriesTreeModel(QAbstractItemModel):
    def __init__(self, execute_query, role_names):
        super().__init__()
        self.quiz = Quiz()
        self.execute_query = execute_query
        self.roleNames = lambda: role_names

    @Slot()
    def resetQuiz(self):
        self.quiz = Quiz()

    @Slot(int, str)
    def delete(self, _id, _type):
        if self.execute_query(f"DELETE FROM {_type} WHERE id={_id}"):
            i = self.getElementIndex(_id, _type)
            self.removeRow(i.row(), i)

    def set_quiz(self, quiz):
        self.quiz = quiz

    def columnCount(self, index=QModelIndex()):
        return 1

    def rowCount(self, parent):
        if parent.isValid():
            item = parent.internalPointer()
            # if isinstance(item, Quiz):
            #     return len(item.categories)
            if isinstance(item, Category):
                return len(item.questions)
            return 0
        else:
            return len(self.quiz.categories)

    def removeRow(self, i, element=QModelIndex()):  # i == element.row()
        if not element.isValid():
            return
        parent = self.parent(element)
        self.beginRemoveRows(parent, i, i)
        parent = parent.internalPointer()
        if isinstance(parent, Category):
            del parent.questions[i]
        else:
            del self.quiz.categories[i]
        self.endRemoveRows()

    @Slot(int, str, result='QModelIndex')
    def getElementIndex(self, _id, _type):
        if _type == "category":
            for i, category in enumerate(self.quiz.categories):
                if category.id == _id:
                    return self.createIndex(i, 0, category)
        elif _type == "question":
            for category in self.quiz.categories:
                for i, question in enumerate(category.questions):
                    if question.id == _id:
                        return self.createIndex(i, 0, question)
        return QModelIndex()

    @Slot(QModelIndex, result='QModelIndex')
    def prev(self, i):
        if not i.isValid():
            return QModelIndex()

        item = i.internalPointer()
        if isinstance(item, Category):
            if i.row() == 0:
                return i
            p = self.index(i.row() - 1, 0)
            return self.index(self.rowCount(p) - 1, 0, p)

        p = self.parent(i)
        res = self.index(i.row() - 1, 0, p)
        return res if res.isValid() else p

    @Slot(QModelIndex, result='QModelIndex')
    def next(self, i):
        if not i.isValid():
            return QModelIndex()

        item = i.internalPointer()
        if isinstance(item, Category):
            return self.index(0, 0, i)

        p = self.parent(i)
        res = self.index(i.row() + 1, 0, p)
        if res.isValid():
            return res
        res = self.index(p.row() + 1, 0)
        return res if res.isValid() else i

    @Slot(QModelIndex, result='QVariant')
    def itemData(self, index):
        data = {}
        if not index.isValid():
            return data

        item = index.internalPointer()
        for role in roles.MAPPINGS:
            prop = roles.MAPPINGS.get(role)
            if prop is not None:
                attr = getattr(item, prop, None)
                if attr is not None:
                    data[prop] = attr
        return data

    def index(self, row, column, parent=QModelIndex()):
        if column != 0:
            return QModelIndex()
        if not self.hasIndex(row, column, parent):
            return QModelIndex()
        if parent.isValid():
            item = parent.internalPointer()
            # if isinstance(item, Quiz):
            #     return self.createIndex(row, column, item.categories[row])
            if isinstance(item, Category):
                return self.createIndex(row, column, item.questions[row])
            return QModelIndex()
        else:
            return self.createIndex(row, column, self.quiz.categories[row])

    def parent(self, index):
        if not index.isValid():
            return QModelIndex()
        item = index.internalPointer()
        if isinstance(item, Category):
            # root object (quiz) is not displayed, categories are at the root
            # this also means that their parent in this model is None !
            return QModelIndex()
        elif isinstance(item, Question):
            row = -1
            parent_item = None
            for i, category in enumerate(self.quiz.categories):
                if item in category.questions:
                    row = i
                    parent_item = category
                    break
            if row >= 0:
                return self.createIndex(row, 0, parent_item)
        return QModelIndex()

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return

        item = index.internalPointer()

        if role == Qt.DisplayRole:
            return item.name
        prop = roles.MAPPINGS.get(role)
        if prop is not None:
            return getattr(item, prop)

    def setData(self, index, *args, **kwargs):
        if not index.isValid():
            return False

        value, role = args
        item = index.internalPointer()
        prop = roles.MAPPINGS.get(role)
        if prop is not None and getattr(item, prop) is not None:
            setattr(item, prop, value)
            self.dataChanged.emit(index, index)
            return True

        return False

    @Slot(QModelIndex, str)
    def updateCategoryName(self, index, name):
        if not index.isValid():
            return

        _id = self.data(index, roles.IdRole)
        if self.execute_query(f"UPDATE category SET name='{name}' WHERE id={_id}"):
            self.setData(index, name, roles.NameRole)

    @Slot(QModelIndex, QJSValue)
    def updateQuestion(self, index, data):
        if not index.isValid():
            return

        change = []
        for key, value in self.itemData(index).items():
            if key == "points":
                prop = data.property(key).toUInt()
            else:
                prop = data.property(key).toString()

            if prop not in ["undefined", value]:
                if type(prop) == str:
                    # xss for string with apostrophes prevention
                    prop = prop.replace("'", "''")
                    prop = f"'{prop}'"
                change.append((key, prop))

        if len(change) == 0:
            return

        query = [f"\"{key}={prop}\"" for key, prop in change]
        pattern = re.compile(r'[\[\]\\]|\"\'|(?<!\\)\'\"')
        query = re.sub(pattern, '', str(query))
        _id = self.data(index, roles.IdRole)
        query = f"UPDATE question SET {query} WHERE id={_id}"

        if self.execute_query(query):
            roles_keys = list(roles.MAPPINGS.keys())
            roles_values = list(roles.MAPPINGS.values())
            for key, p in change:
                self.setData(
                    index,
                    p if type(p) != str else p[1:-1].replace("''", "'"),
                    roles_keys[roles_values.index(key)]
                )


class QuizListModel(QAbstractListModel):
    def __init__(self,
                 quizzes,
                 get_quiz_details,
                 set_current_quiz,
                 execute_query,
                 role_names):
        QAbstractListModel.__init__(self)
        self._quizzes = quizzes
        self.get_quiz_details = get_quiz_details
        self.set_current_quiz = set_current_quiz
        self.execute_query = execute_query
        self.roleNames = lambda: role_names

    def rowCount(self, parent=QModelIndex()):
        return len(self._quizzes)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return

        item = self._quizzes[index.row()]

        if role == Qt.DisplayRole:
            return item.name
        prop = roles.MAPPINGS.get(role)
        if prop is not None:
            return getattr(item, prop)

    def add_row(self, q):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._quizzes.append(q)
        self.endInsertRows()

    def removeRow(self, i, parent=QModelIndex()):
        self.beginRemoveRows(parent, i, i)
        del self._quizzes[i]
        self.endRemoveRows()

    @Slot(int)
    def play(self, _id):
        print("Play:", _id)

    @Slot(int)
    def details(self, index):
        item = self._quizzes[index]
        categories = self.get_quiz_details(item.id)
        item.categories = categories
        self.set_current_quiz(item)

    @Slot(int)
    def delete(self, index):
        item = self._quizzes[index]
        if self.execute_query(f"DELETE FROM quiz WHERE id={item.id}"):
            self.removeRow(index)

    @Slot(QModelIndex, str)
    def updateQuizName(self, index, name):
        if not index.isValid():
            return

        item = self._quizzes[index.row()]
        if self.execute_query(f"UPDATE quiz SET name='{name}' WHERE id={item.id}"):
            item.name = name
            self.dataChanged.emit(index, index)
