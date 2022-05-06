from PySide6.QtCore import QDir, QFile
from PySide6.QtSql import QSqlDatabase, QSqlQuery
from dataclasses import dataclass


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
                FOREIGN KEY (quiz_id) REFERENCES quiz (id)
            );
        """)

        self.query.exec_("""
            CREATE TABLE IF NOT EXISTS question (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
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
                FOREIGN KEY (category_id) REFERENCES category (id),
                FOREIGN KEY (question_id) REFERENCES question (id)
            );
        """)

        self.query.exec_("""       
            CREATE TABLE IF NOT EXISTS choice (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                choice TEXT NOT NULL,
                question_id INTEGER NOT NULL,
                FOREIGN KEY (question_id) REFERENCES question (id)
            );
        """)


@dataclass
class Quiz:
    _id: int  # private by convention
    name: str

    @property
    def id(self):  # read-only
        return self._id
