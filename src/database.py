from PySide6.QtCore import QDir, QFile
from PySide6.QtSql import QSqlDatabase, QSqlQuery


def connect():
    database = QSqlDatabase.database()
    if not database.isValid():
        database = QSqlDatabase.addDatabase("QSQLITE")
        if not database.isValid():
            print("Cannot add database")

    write_dir = QDir("")
    if not write_dir.mkpath("."):
        print("Failed to create writable directory")

    # Ensure that we have a writable location on all devices.
    abs_path = write_dir.absolutePath()
    filename = f"{abs_path}/db.sqlite3"

    # When using the SQLite driver, open() will create the SQLite
    # database if it doesn't exist.
    database.setDatabaseName(filename)
    if not database.open():
        print("Cannot open database")
        QFile.remove(filename)


def create_tables():
    table_names = [
        "quiz",
        "category",
        "question",
        "category_question",
        "choice",
    ]

    if all(table in QSqlDatabase.database().tables() for table in table_names):
        return

    query = QSqlQuery()

    # from the docs (https://doc.qt.io/qt-6/qsqlquery.html#exec):
    # For SQLite, the query string can contain only one statement at a time.
    query.exec_("""
        CREATE TABLE IF NOT EXISTS quiz (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
        );
    """)

    query.exec_("""
        CREATE TABLE IF NOT EXISTS category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            quiz_id INTEGER NOT NULL,
            FOREIGN KEY (quiz_id) REFERENCES quiz (id)
        );
    """)

    query.exec_("""
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

    query.exec_("""
        CREATE TABLE IF NOT EXISTS category_question (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL,
            question_id INTEGER NOT NULL,
            FOREIGN KEY (category_id) REFERENCES category (id),
            FOREIGN KEY (question_id) REFERENCES question (id)
        );
    """)

    query.exec_("""       
        CREATE TABLE IF NOT EXISTS choice (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            choice TEXT NOT NULL,
            question_id INTEGER NOT NULL,
            FOREIGN KEY (question_id) REFERENCES question (id)
        );
    """)
