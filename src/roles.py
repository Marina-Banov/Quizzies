from enum import IntEnum, auto

from PySide6.QtCore import Qt


ModelIndexRole = Qt.UserRole
TypeRole = Qt.UserRole + 1
IdRole = Qt.UserRole + 2
NameRole = Qt.UserRole + 3


class QuestionRoles(IntEnum):
    QuestionRole = Qt.UserRole + 4
    AnswerRole = auto()
    QTypeRole = auto()
    PointsRole = auto()
    ImageRole = auto()


MAPPINGS = {
    ModelIndexRole: "modelIndex",
    TypeRole: "type",
    IdRole: "id",
    NameRole: "name",
    QuestionRoles.QuestionRole: "question",
    QuestionRoles.AnswerRole: "answer",
    QuestionRoles.QTypeRole: "qtype",
    QuestionRoles.PointsRole: "points",
    QuestionRoles.ImageRole: "image",
}
