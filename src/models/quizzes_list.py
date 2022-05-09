from PySide6.QtCore import QAbstractListModel, QModelIndex, QObject, Qt, Slot


class QuizListModel(QAbstractListModel):
    def __init__(self, quizzes, get_quiz_details, set_current_quiz):
        QAbstractListModel.__init__(self)
        self._quizzes = quizzes
        self.get_quiz_details = get_quiz_details
        self.set_current_quiz = set_current_quiz

    def rowCount(self, parent=QModelIndex()):
        return len(self._quizzes)

    def data(self, index, role=None):
        if index.isValid() and role == Qt.DisplayRole:
            return self._quizzes[index.row()]
        return None

    def add_row(self, q):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._quizzes.append(q)
        self.endInsertRows()

    @Slot(QObject)
    def print(self, obj):
        print("User clicked on:", obj.obj)

    @Slot(QObject)
    def play(self, obj):
        print("Play:", obj.obj)

    @Slot(int)
    def details(self, index):
        categories = self.get_quiz_details(self._quizzes[index].obj.id)
        self._quizzes[index].obj.categories = categories
        self.set_current_quiz(self._quizzes[index].obj)

    @Slot(QObject)
    def edit(self, obj):
        print("Edit:", obj.obj)

    @Slot(QObject)
    def delete(self, obj):
        print("Delete:", obj.obj)
