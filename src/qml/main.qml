import QtQuick
import QtQuick.Controls
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

    StackView {
       id: stack
       initialItem: "homePage.qml"
       anchors.fill: parent
    }
}
