from PySide6.QtCore import QAbstractListModel, QModelIndex, \
    QObject, Qt, Property, Signal, Slot


class Quiz:
    def __init__(self, quiz_dict):
        self.id = quiz_dict["id"]
        self.name = quiz_dict["name"]

    def __str__(self):
        return self.name


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
    def __init__(self, quizzes):
        QAbstractListModel.__init__(self)
        self._quizzes = quizzes

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


class Controller(QObject):
    @Slot(QObject)
    def print(self, obj):
        print("User clicked on:", obj.obj)
