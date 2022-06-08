import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "."


Item {
    width: 600; height: 500

    FontLoader {
        id: patuaOne
        source: "qrc:///assets/PatuaOne-Regular.ttf"
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
            property alias name: nameField.text
            property alias placeholder: nameField.placeholderText
            x: { (parent.width - width) / 2 }
            y: { (parent.height - height) / 2 }
            standardButtons: Dialog.Ok | Dialog.Cancel
            TextField {
                id: nameField
                topPadding: 6
                bottomPadding: 6
                leftPadding: 8
                rightPadding: 8
                width: parent.width
            }
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
