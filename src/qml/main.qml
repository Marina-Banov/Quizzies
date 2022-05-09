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

    QtObject{
        id: internals
        property int currentIndex: -1
    }

    Component {
        id: dialogDelete

        Dialog {
            id: dialog
            title: "Brisanje"
            Label{
            text: "Sigurno želite obrisati ovu stavku?"}
            modal: true
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            onVisibleChanged: if(!visible) destroy(1)
            standardButtons: Dialog.No | Dialog.Yes
            Component.onCompleted: {
                dialog.standardButton(Dialog.Yes).text = "Da"
                dialog.standardButton(Dialog.No).text = "Ne"
            }
        }
    }

    StackView {
       id: stack
       initialItem: "homePage.qml"
       anchors.fill: parent
    }
}
