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
    def __init__(self, execute_query, last_insert_id, role_names):
        super().__init__()
        self.quiz = Quiz()
        self.execute_query = execute_query
        self.last_insert_id = last_insert_id
        self.roleNames = lambda: role_names
        self.columnCount = lambda i: 1

    @Slot(int, str)
    def delete(self, _id, _type):
        # TODO could mess up all questions orders...
        #  maybe remove it from the db?
        if self.execute_query(f"DELETE FROM {_type} WHERE id={_id}"):
            i = self.getElementIndex(_id, _type)
            self.removeRow(i.row(), self.parent(i))
        else:
            print("Failed to execute query")

    def set_quiz(self, quiz):
        self.quiz = quiz

    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            item = parent.internalPointer()
            # if isinstance(item, Quiz):
            #     return len(item.categories)
            if isinstance(item, Category):
                return len(item.questions)
            return 0
        else:
            return len(self.quiz.categories)

    def insertRow(self, row, parent=QModelIndex(), *args):
        if len(args) == 0:
            return False
        self.beginInsertRows(parent, row, row)
        if parent.isValid():
            self.quiz.categories[parent.row()].questions.append(args[0])
        else:
            self.quiz.categories.append(args[0])
        self.endInsertRows()
        return True

    def removeRow(self, row, parent=QModelIndex()):
        self.beginRemoveRows(parent, row, row)
        if parent.isValid():
            p = parent.internalPointer()
            del p.questions[row]
        else:
            del self.quiz.categories[row]
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
        p = self.parent(i)
        if isinstance(item, Category):
            if i.row() == 0:
                return i
            p = self.index(i.row() - 1, 0)
            res = self.index(self.rowCount(p) - 1, 0, p)
            if res.isValid():
                return res
            res = p
        else:
            res = self.index(i.row() - 1, 0, p)
        return res if res.isValid() else p

    @Slot(QModelIndex, result='QModelIndex')
    def next(self, i):
        if not i.isValid():
            return QModelIndex()

        item = i.internalPointer()
        p = self.parent(i)
        if isinstance(item, Category):
            res = self.index(0, 0, i)
            if res.isValid():
                return res
            res = self.index(i.row() + 1, 0)
        else:
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

    def parent(self, index=QModelIndex()):
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
    def updateCategory(self, index, name):
        if not index.isValid():
            return

        _id = self.data(index, roles.IdRole)
        if self.execute_query(f"UPDATE category SET name='{name}' WHERE id={_id}"):
            self.setData(index, name, roles.NameRole)
        else:
            print("Failed to execute query")

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
        pattern = re.compile(r'[\[\]\\]|(?<!\\)((\'\")|(\"\'))')
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
        else:
            print("Failed to execute query")

    @Slot(str)
    def createCategory(self, name):
        if self.execute_query(f"INSERT INTO category(name, quiz_id) "
                              f"VALUES ('{name}', {self.quiz.id})"):
            self.insertRow(len(self.quiz.categories), QModelIndex(),
                           Category(self.last_insert_id(), name))
        else:
            print("Failed to execute query")

    @Slot(str, QModelIndex, result='QModelIndex')
    def createQuestion(self, name, category):
        row = self.rowCount(category)
        if self.execute_query(f"INSERT INTO question(name, qtype, 'order') "
                              f"VALUES ('{name}', 1, '{row+1}')"):
            q_id = self.last_insert_id()
            c_id = self.data(category, roles.IdRole)
            if self.execute_query(f"INSERT INTO category_question( "
                                  f"category_id, question_id) "
                                  f"VALUES ({c_id}, {q_id})"):
                self.insertRow(row, category,
                               Question(q_id, name, 1, str(row+1)))
                return self.index(row, 0, category)
        print("Failed to execute query")
        return QModelIndex()


class QuizListModel(QAbstractListModel):
    def __init__(self,
                 quizzes,
                 get_quiz_details,
                 set_current_quiz,
                 execute_query,
                 last_insert_id,
                 role_names):
        super().__init__()
        self._quizzes = quizzes
        self.get_quiz_details = get_quiz_details
        self.set_current_quiz = set_current_quiz
        self.execute_query = execute_query
        self.last_insert_id = last_insert_id
        self.roleNames = lambda: role_names
        self.rowCount = lambda p: len(self._quizzes)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return

        item = self._quizzes[index.row()]

        if role == Qt.DisplayRole:
            return item.name
        prop = roles.MAPPINGS.get(role)
        if prop is not None:
            return getattr(item, prop)

    def insertRow(self, row, parent=QModelIndex(), *args):
        if len(args) == 0:
            return False
        self.beginInsertRows(QModelIndex(), row, row)
        self._quizzes.insert(row, args[0])
        self.endInsertRows()
        return True

    def removeRow(self, row, parent=QModelIndex()):
        self.beginRemoveRows(parent, row, row)
        del self._quizzes[row]
        self.endRemoveRows()

    @Slot(int)
    def details(self, index):
        item = self._quizzes[index]
        categories = self.get_quiz_details(item.id)
        item.categories = categories
        self.set_current_quiz(item)

    @Slot(str, result='bool')
    def create(self, name):
        if self.execute_query(f"INSERT INTO quiz(name) VALUES ('{name}')"):
            return self.insertRow(0, QModelIndex(),
                                  Quiz(self.last_insert_id(), name))
        print("Failed to execute query")

    @Slot(QModelIndex, str)
    def update(self, index, name):
        if not index.isValid():
            return

        item = self._quizzes[index.row()]
        if self.execute_query(f"UPDATE quiz SET name='{name}' WHERE id={item.id}"):
            item.name = name
            self.dataChanged.emit(index, index)
        else:
            print("Failed to execute query")

    @Slot(int)
    def delete(self, index):
        item = self._quizzes[index]
        if self.execute_query(f"DELETE FROM quiz WHERE id={item.id}"):
            self.removeRow(index)
        else:
            print("Failed to execute query")
