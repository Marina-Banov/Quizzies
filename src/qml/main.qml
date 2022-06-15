import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "."


Item {
    width: 600; height: 500

    FontLoader {
        id: merriweather
        source: "qrc:///assets/Merriweather-Black.ttf"
    }

    FontLoader {
        id: lato
        source: "qrc:///assets/Lato-Regular.ttf"
    }

    QtObject {
        id: internals
        property var currentQuizIndex: null
    }

    Component {
        id: dialogCreate

        Dialog {
            modal: true
            x: { (parent.width - width) / 2 }
            y: { (parent.height - height) / 2 }
            width: 180

            property alias label: label
            property alias nameField: nameField
            ColumnLayout {
                anchors.fill: parent
                Label { id: label }
                TextField {
                    id: nameField
                    topPadding: 6
                    bottomPadding: 6
                    leftPadding: 8
                    rightPadding: 8
                    Layout.fillWidth: true
                }
            }

            standardButtons: Dialog.Ok | Dialog.Cancel
            Component.onCompleted: {
                standardButton(Dialog.Cancel).text = "Odustani";
            }
            onVisibleChanged: { if(!visible) destroy(1) }
        }
    }

    Component {
        id: dialogDelete

        Dialog {
            modal: true
            x: { (parent.width - width) / 2 }
            y: { (parent.height - height) / 2 }
            title: "Brisanje"
            Label { text: "Sigurno želite obrisati ovu stavku?" }
            standardButtons: Dialog.No | Dialog.Yes
            Component.onCompleted: {
                standardButton(Dialog.Yes).text = "Da";
                standardButton(Dialog.No).text = "Ne";
            }
            onVisibleChanged: { if(!visible) destroy(1) }
        }
    }

    StackView {
       id: stack
       initialItem: "QuizziesHomePage.qml"
       anchors.fill: parent
    }
}
