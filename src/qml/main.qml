import QtQuick
import QtQuick.Controls


Item {
    width: 600; height: 500

    StackView {
       id: stack
       initialItem: "homePage.qml"
       anchors.fill: parent
    }
}
