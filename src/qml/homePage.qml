import QtQuick
import QtQuick.Controls


Page {
    id: homePage

    Rectangle {
        id: root
        anchors.fill: parent

        Image {
            id: background
            fillMode: Image.PreserveAspectCrop
            anchors.fill: root
            source: "qrc:///assets/bg.png"
        }

        Text {
            id: textTitle
            width: 400
            x: 50; y: 90
            wrapMode: Text.WordWrap
            // text: qsTr("Dobrodošli u Quizzies!")
            text: "Dobrodošli u Quizzies!"
            font.family: patuaOne.name
            font.pointSize: 44
            color: "#880d26"
        }

        Text {
            id: textDescription
            width: 500
            anchors.topMargin: 25
            anchors.leftMargin: 5
            anchors.top: textTitle.bottom
            anchors.left: textTitle.left
            // text: qsTr("Jeste li spremni za dobar provod s prijateljima?\nPokažite tko je među vama uvijek spreman na najteža pitanja i najbolju zabavu!")
            text: "Jeste li spremni za dobar provod s prijateljima?\nPokažite tko među vama zna odgovore na najteža pitanja i zabavite se!"
            font.family: lato.name
            wrapMode: Text.WordWrap
            font.pointSize: 14
            color: "#B11030"
        }

        Row {
            anchors.topMargin: 25
            anchors.top: textDescription.bottom
            anchors.left: textDescription.left
            width: textDescription.width
            spacing: 25

            RoundGradientButton {
                id: btnNewQuiz
                // text: qsTr("NOVI KVIZ")
                text: "NOVI KVIZ"
                onClicked: homePage.StackView.view.push("editPage.qml")
            }

            RoundGradientButton {
                id: btnOpenQuiz
                visible: if(root.width < 828) return true; else false
                // text: qsTr("ODABERI KVIZ")
                text: "ODABERI KVIZ"
                onClicked: animationMenu.running = true
            }
        }

        Rectangle {
            id: menu
            width: if(root.width >= 828) return 300; else return 0
            height: parent.height
            color: "#ffffff"
            opacity: 0.85
            anchors.right: parent.right

            PropertyAnimation {
                id: animationMenu
                target: menu
                property: "width"
                to: if(menu.width == 0) return 200;
                duration: 400
                easing.type: Easing.InOutQuint
            }

            ListView {
               anchors.fill: parent
               model: quizzesModel
               delegate: Component {
                   Rectangle {
                       width: parent.width
                       height: 40
                       color: "white"
                       Text {
                           text: model.display.name
                           color: "#B11030"
                           font.family: lato.name
                           font.pointSize: 12
                           anchors.leftMargin: 10
                           anchors.fill: parent
                           verticalAlignment: Text.AlignVCenter
                       }
                       MouseArea {
                           anchors.fill: parent
                           onClicked: { controller.print(model.display) }
                       }
                   }
               }
            }
        }
    }
}
