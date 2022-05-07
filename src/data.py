from dataclasses import dataclass, field
from dataclasses_json import dataclass_json  # TODO possibly remove

from PySide6.QtCore import QDir, QFile
from PySide6.QtSql import QSqlDatabase, QSqlQuery


class Database:
    def __init__(self):
        self.database = QSqlDatabase.database()
        self.connect()
        self.query = QSqlQuery()
        self.create_tables()

    def get_quizzes(self):
        self.query.exec_(f"SELECT * FROM quiz ORDER BY id DESC")
        result = []
        while self.query.next():
            result.append(
                Quiz(self.query.value("id"), self.query.value("name"))
            )
            # https://docs.python.org/3/library/sqlite3.html#sqlite3.Cursor.fetchall
            # result.append(tuple(query.value(f) for f in fields))
        return result

    def get_quiz_details(self, quiz_id):
        self.query.exec_(f"SELECT * FROM category WHERE quiz_id={quiz_id}")
        categories = []
        while self.query.next():
            category_id = self.query.value("id")
            subquery = QSqlQuery()
            subquery.exec_(f"SELECT * FROM category_question cq "
                           f"JOIN question q ON q.id = cq.question_id "
                           f"WHERE category_id={category_id}")
            questions = []
            while subquery.next():
                questions.append(
                    Question(
                        subquery.value("id"),
                        subquery.value("short_code"),
                        subquery.value("question"),
                        subquery.value("answer"),
                        subquery.value("type"),
                        subquery.value("order"),
                        subquery.value("points")
                    )
                )
            categories.append(
                Category(category_id, self.query.value("name"), questions)
            )

        return categories

    def connect(self):
        if not self.database.isValid():
            self.database = QSqlDatabase.addDatabase("QSQLITE")
            if not self.database.isValid():
                print("Cannot add database")

        write_dir = QDir("")
        if not write_dir.mkpath("."):
            print("Failed to create writable directory")

        # Ensure that we have a writable location on all devices.
        abs_path = write_dir.absolutePath()
        filename = f"{abs_path}/db.sqlite3"

        # When using the SQLite driver, open() will create the SQLite
        # database if it doesn't exist.
        self.database.setDatabaseName(filename)
        if not self.database.open():
            print("Cannot open database")
            QFile.remove(filename)

    def create_tables(self):
        table_names = [
            "quiz",
            "category",
            "question",
            "category_question",
            "choice",
        ]

        if all(table in self.database.tables() for table in table_names):
            return

        # from the docs (https://doc.qt.io/qt-6/qsqlquery.html#exec):
        # For SQLite, the query string can contain only one statement at a time
        self.query.exec_("""
            CREATE TABLE IF NOT EXISTS quiz (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
            );
        """)

        self.query.exec_("""
            CREATE TABLE IF NOT EXISTS category (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                quiz_id INTEGER NOT NULL,
                FOREIGN KEY (quiz_id) REFERENCES quiz (id) ON DELETE CASCADE
            );
        """)

        self.query.exec_("""
            CREATE TABLE IF NOT EXISTS question (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                short_code VARCHAR(30) NOT NULL,
                question TEXT NOT NULL,
                answer TEXT NOT NULL,
                type INTEGER NOT NULL,
                'order' TEXT NOT NULL,
                points INTEGER NOT NULL,
                image BLOB
            );
        """)

        self.query.exec_("""
            CREATE TABLE IF NOT EXISTS category_question (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                category_id INTEGER NOT NULL,
                question_id INTEGER NOT NULL,
                FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
                FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE
            );
        """)

        self.query.exec_("""       
            CREATE TABLE IF NOT EXISTS choice (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                choice TEXT NOT NULL,
                question_id INTEGER NOT NULL,
                FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE
            );
        """)


@dataclass_json
@dataclass
class Choice:
    _id: int  # private by convention
    choice: str

    @property
    def id(self):  # read-only
        return self._id


@dataclass_json
@dataclass
class Question:
    _id: int
    short_code: str
    question: str
    answer: str
    _type: int
    order: str
    points: int
    image: str = ""
    choices: list[Choice] = field(default_factory=list)

    @property
    def id(self):
        return self._id


@dataclass_json
@dataclass
class Category:
    _id: int
    name: str
    questions: list[Question] = field(default_factory=list)

    @property
    def id(self):
        return self._id


@dataclass_json
@dataclass
class Quiz:
    _id: int = 0
    name: str = ""
    categories: list[Category] = field(default_factory=list)

    @property
    def id(self):
        return self._id
