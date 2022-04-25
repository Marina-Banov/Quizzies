import sys
# import urllib.request
# import json
from pathlib import Path

from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QStringListModel, QUrl
from PySide6.QtGui import QGuiApplication, QIcon

import qrc  # static resources


def main():
    # Get our data
    # url = "http://country.io/names.json"
    # response = urllib.request.urlopen(url)
    # data = json.loads(response.read().decode('utf-8'))

    # Format and sort the data
    # data_list = list(data.values())
    # data_list.sort()

    # Set up the application window
    app = QGuiApplication(sys.argv)
    window = QQuickView()
    window.setIcon(QIcon(":/assets/favicon.png"))
    window.setTitle("Quizzies")
    window.setResizeMode(QQuickView.SizeRootObjectToView)

    # Expose the list to the Qml code
    # my_model = QStringListModel()
    # my_model.setStringList(data_list)
    # view.setInitialProperties({"myModel": my_model})

    # Load the QML file
    qml_file = Path(__file__).parent / "qml/homePage.qml"
    window.setSource(QUrl.fromLocalFile(qml_file.resolve()))

    # Show the window
    if window.status() == QQuickView.Error:
        sys.exit(-1)
    window.show()

    # Execute and cleanup
    app.exec()
    del window


if __name__ == '__main__':
    main()
