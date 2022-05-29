from PySide6.QtCore import (
    QAbstractListModel,
    QAbstractItemModel,
    QModelIndex,
    Qt,
    Slot,
)

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
        if i == -1 or not element.isValid():
            return
        parent = self.parent(element)
        self.beginRemoveRows(parent, i, i)
        parent = parent.internalPointer()
        if isinstance(parent, Category):
            del parent.questions[i]
        else:
            del self.quiz.categories[i]
        self.endRemoveRows()

    @Slot(int, str, result=QModelIndex)
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
