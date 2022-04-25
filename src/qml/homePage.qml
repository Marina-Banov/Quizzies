import QtQuick
import QtQuick.Controls


Page {
    width: 600; height: 500

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
        height: parent.height; width: parent.width

        Image {
            id: background
            fillMode: Image.PreserveAspectCrop
            anchors.fill: root
            source: "qrc:///assets/bg.png"
        }

        Text {
            id: title
            width: 400
            x: 50; y: 90
            wrapMode: Text.WordWrap
            // text: qsTr("Dobrodošli u Quizzies!")
            text: "Dobrodošli u Quizzies!"
            font.family: patuaOne.name
            font.pointSize: 44
            color: "#B11030"
        }

        Text {
            id: description
            width: 500
            anchors.topMargin: 25
            anchors.leftMargin: 5
            anchors.top: title.bottom
            anchors.left: title.left
            // text: qsTr("Jeste li spremni za dobar provod s prijateljima?\nPokažite tko je među vama uvijek spreman na najteža pitanja i najbolju zabavu!")
            text: "Jeste li spremni za dobar provod s prijateljima?\nPokažite tko među vama zna odgovore na najteža pitanja i zabavite se!"
            font.family: lato.name
            wrapMode: Text.WordWrap
            font.pointSize: 14
            color: "#B11030"
        }

        RoundButton {
            id: button
            width: 140; height: 40
            anchors.topMargin: 25
            anchors.top: description.bottom
            anchors.left: description.left
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
                text: "NOVI KVIZ"
                font.family: patuaOne.name
                font.pointSize: 12
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
