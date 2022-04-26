import QtQuick
import QtQuick.Controls


RoundButton {
    id: button
    implicitWidth: 140; implicitHeight: 40

    background: Rectangle {
        radius: parent.radius
        gradient: Gradient {
          GradientStop {
              position: 0
              color: button.pressed ? "#ff1a95" : "#ff3e9f"
          }
          GradientStop {
              position: 1
              color: button.pressed ? "#ff6442" : "#ff7a5c"
          }
        }
    }

    contentItem: Text {
        text: button.text
        font.family: patuaOne.name
        font.pointSize: 12
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
