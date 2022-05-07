from PySide6.QtCore import QAbstractListModel, QModelIndex, \
    QObject, Qt, Property, Signal, Slot


class QObjectWrapper(QObject):
    def __init__(self, obj):
        QObject.__init__(self)
        self._obj = obj

    @property
    def obj(self):
        return self._obj

    def _name(self):
        return self._obj.name

    changed = Signal()
    name = Property(str, _name, notify=changed)


class QuizListModel(QAbstractListModel):
    def __init__(self, quizzes, db):
        QAbstractListModel.__init__(self)
        self._quizzes = quizzes
        self._db = db

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
        categories = self._db.get_quiz_details(self._quizzes[index].obj.id)
        self._quizzes[index].obj.categories = categories

    @Slot(QObject)
    def edit(self, obj):
        print("Edit:", obj.obj)

    @Slot(QObject)
    def delete(self, obj):
        print("Delete:", obj.obj)
