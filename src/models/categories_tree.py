from enum import IntEnum, auto

from PySide6.QtCore import (
    QAbstractItemModel,
    QByteArray,
    QModelIndex,
    Qt,
    Slot,
    QObject,
)

from data import Question, Category, Quiz  # TODO import issues


class CategoryRoles(IntEnum):
    NameRole = Qt.UserRole
    IdRole = auto()
    TypeRole = auto()


class QuestionRoles(IntEnum):
    ShortCodeRole = CategoryRoles.TypeRole + 1
    QuestionRole = auto()
    AnswerRole = auto()
    TypeRole = auto()
    OrderRole = auto()
    PointsRole = auto()


ROLES_MAPPING = {
    CategoryRoles.NameRole: "name",
    CategoryRoles.IdRole: "id",
    CategoryRoles.TypeRole: "type",
    QuestionRoles.ShortCodeRole: "shortCode",
    QuestionRoles.QuestionRole: "question",
    QuestionRoles.AnswerRole: "answer",
    QuestionRoles.TypeRole: "type",
    QuestionRoles.OrderRole: "order",
    QuestionRoles.PointsRole: "points",
}


class CategoriesTreeModel(QAbstractItemModel):
    def __init__(self, quiz, execute_query):
        super().__init__()
        self.quiz = quiz
        self._rolenames = dict()
        self._rolenames[Qt.DisplayRole] = QByteArray(b"display")
        for role, name in ROLES_MAPPING.items():
            self._rolenames[role] = QByteArray(name.encode())
        self.execute_query = execute_query

    @Slot()
    def resetQuiz(self):
        self.quiz = Quiz()

    @Slot(int, str)
    def delete(self, _id, _type):
        print(_id, _type)
        self.execute_query(f"DELETE FROM {_type} WHERE id={_id}")

    def set_quiz(self, quiz):
        self.quiz = quiz

    def columnCount(self, index=QModelIndex()):
        return 1

    def roleNames(self):
        return self._rolenames

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
            if isinstance(item, Quiz):
                return item.name
            elif isinstance(item, Category):
                return item.name
            elif isinstance(item, Question):
                return item.short_code
            return
        elif role == CategoryRoles.IdRole:
            return item.id
        elif role == CategoryRoles.TypeRole:
            if isinstance(item, Quiz):
                return "quiz"
            elif isinstance(item, Category):
                return "category"
            elif isinstance(item, Question):
                return "question"
            return
        # else:
        #     prop = ROLES_MAPPING.get(role)
        #     if prop is not None:
        #         return getattr(item, prop)
