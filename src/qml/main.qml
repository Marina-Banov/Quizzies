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
        id: dialogDelete

        Dialog {
            id: dialog
            modal: true
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            title: "Brisanje"
            Label { text: "Sigurno želite obrisati ovu stavku?" }
            standardButtons: Dialog.No | Dialog.Yes
            Component.onCompleted: {
                dialog.standardButton(Dialog.Yes).text = "Da"
                dialog.standardButton(Dialog.No).text = "Ne"
            }
            onVisibleChanged: if(!visible) destroy(1)
        }
    }

    StackView {
       id: stack
       initialItem: "homePage.qml"
       anchors.fill: parent
    }
}
