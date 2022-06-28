from dataclasses import dataclass, field


@dataclass
class Choice:
    _id: int  # private by convention
    choice: str

    @property
    def id(self):  # read-only
        return self._id


@dataclass
class Question:
    _id: int
    name: str
    qtype: int
    question: str = ""
    answer: str = ""
    points: int = ""
    image: str = ""
    choices: list[Choice] = field(default_factory=list)
    type = "question"

    @property
    def id(self):
        return self._id


@dataclass
class Category:
    _id: int
    name: str
    questions: list[Question] = field(default_factory=list)
    type = "category"

    @property
    def id(self):
        return self._id


@dataclass
class Quiz:
    _id: int = 0
    name: str = ""
    categories: list[Category] = field(default_factory=list)
    type = "quiz"

    @property
    def id(self):
        return self._id
