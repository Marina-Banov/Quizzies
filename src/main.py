import sys
from pathlib import Path

from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon

import qrc  # static resources
from data import Database, Quiz
from models.object_wrapper import QObjectWrapper
from models.quizzes_list import QuizListModel
from models.categories_tree import CategoriesTreeModel

sys.path.append(str(Path(__file__).resolve()))


def main():
    db = Database()
    quizzes = db.get_quizzes()

    # Set up the application window
    app = QGuiApplication(sys.argv)
    window = QQuickView()
    window.setIcon(QIcon(":/assets/favicon.png"))
    window.setTitle("Quizzies")
    window.setResizeMode(QQuickView.SizeRootObjectToView)

    # Expose the data to the QML code
    categories_model = CategoriesTreeModel(Quiz())
    quizzes = [QObjectWrapper(q) for q in quizzes]
    quizzes_model = QuizListModel(quizzes,
                                  db.get_quiz_details,
                                  categories_model.set_quiz)
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
    del window


if __name__ == "__main__":
    main()
