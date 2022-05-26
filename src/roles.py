from enum import IntEnum, auto

from PySide6.QtCore import Qt


TypeRole = Qt.UserRole
IdRole = Qt.UserRole + 1
NameRole = Qt.UserRole + 2


class QuestionRoles(IntEnum):
    QuestionRole = Qt.UserRole + 3
    AnswerRole = auto()
    QTypeRole = auto()
    OrderRole = auto()
    PointsRole = auto()
    ImageRole = auto()


MAPPINGS = {
    TypeRole: "type",
    IdRole: "id",
    NameRole: "name",
    QuestionRoles.QuestionRole: "question",
    QuestionRoles.AnswerRole: "answer",
    QuestionRoles.QTypeRole: "qtype",
    QuestionRoles.OrderRole: "order",
    QuestionRoles.PointsRole: "points",
    QuestionRoles.ImageRole: "image",
}
