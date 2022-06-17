import sys
from pathlib import Path

from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl, Qt, QByteArray
from PySide6.QtGui import QGuiApplication, QIcon

import qrc  # static resources
from data import Database
from models import QuizListModel, CategoriesTreeModel
import roles


def main():
    role_names = dict()
    role_names[Qt.DisplayRole] = QByteArray(b"display")
    for role, name in roles.MAPPINGS.items():
        role_names[role] = QByteArray(name.encode())

    db = Database()
    quizzes = db.get_quizzes()

    # Set up the application window
    app = QGuiApplication(sys.argv)
    window = QQuickView()
    window.setIcon(QIcon(":/assets/favicon.png"))
    window.setTitle("Quizzies")
    window.setResizeMode(QQuickView.SizeRootObjectToView)

    # Expose the data to the QML code
    categories_model = CategoriesTreeModel(db.execute_query,
                                           db.last_insert_id,
                                           role_names)
    quizzes_model = QuizListModel(quizzes,
                                  db.get_quiz_details,
                                  categories_model.set_quiz,
                                  db.execute_query,
                                  db.last_insert_id,
                                  role_names)
    rc = window.rootContext()
    rc.setContextProperty("quizzesModel", quizzes_model)
    rc.setContextProperty("categoriesModel", categories_model)

    # Load the QML file
    qml_file = Path(__file__).parent / "qml/main.qml"
    window.setSource(QUrl.fromLocalFile(qml_file.resolve()))

    # Show the window
    if window.status() == QQuickView.Error:
        sys.exit(-1)
    window.show()

    # Execute and cleanup
    app.exec()
    del window, app


if __name__ == "__main__":
    main()
