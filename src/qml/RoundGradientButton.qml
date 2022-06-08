import QtQuick
import QtQuick.Controls


RoundButton {
    implicitWidth: 140; implicitHeight: 40
    font.family: patuaOne.name
    font.pointSize: 12
    palette.buttonText: "white"

    background: Rectangle {
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0; color: Style.pink }
            GradientStop { position: 1; color: Style.orange }
        }
        opacity: pressed ? 1 : .9
    }
}
