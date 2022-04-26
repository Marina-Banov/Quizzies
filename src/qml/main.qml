import QtQuick
import QtQuick.Controls


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

    StackView {
       id: stack
       initialItem: "homePage.qml"
       anchors.fill: parent
    }
}
