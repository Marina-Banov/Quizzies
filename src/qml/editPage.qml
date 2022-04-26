import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects


Page {
    id: editPage

    FontLoader {
        id: patuaOne
        source: "qrc:///assets/PatuaOne-Regular.ttf"
    }

    FontLoader {
        id: lato
        source: "qrc:///assets/Lato-Regular.ttf"
    }

    Rectangle {
        id: root
        anchors.fill: parent

        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.2; color: "#FFF3F3" }
                GradientStop { position: 0.75; color: "#FFC8DC" }
            }
        }

        Text {
            id: title
            width: 400
            x: 50; y: 90
            wrapMode: Text.WordWrap
            // text: qsTr("Dobrodošli u Quizzies!")
            text: "Edit page?"
            font.family: patuaOne.name
            font.pointSize: 44
            color: "#880d26"
        }

        RoundButton {
            id: button
            width: 140; height: 40
            anchors.topMargin: 25
            anchors.top: title.bottom
            anchors.left: title.left
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
                // text: qsTr("NOVI KVIZ")
                text: "GO BACK"
                font.family: patuaOne.name
                font.pointSize: 12
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: editPage.StackView.view.pop()
        }
    }
}

