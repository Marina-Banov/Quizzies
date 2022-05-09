from enum import IntEnum, auto

from PySide6.QtCore import Qt


TypeRole = Qt.UserRole
IdRole = Qt.UserRole + 1
NameRole = Qt.UserRole + 2


class QuestionRoles(IntEnum):
    ShortCodeRole = Qt.UserRole + 3
    QuestionRole = auto()
    AnswerRole = auto()
    QTypeRole = auto()
    OrderRole = auto()
    PointsRole = auto()


MAPPINGS = {
    TypeRole: "type",
    IdRole: "id",
    NameRole: "name",
    QuestionRoles.ShortCodeRole: "shortCode",
    QuestionRoles.QuestionRole: "question",
    QuestionRoles.AnswerRole: "answer",
    QuestionRoles.QTypeRole: "qtype",
    QuestionRoles.OrderRole: "order",
    QuestionRoles.PointsRole: "points",
}
