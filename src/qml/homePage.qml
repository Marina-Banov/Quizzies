import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts


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
                delegate: Rectangle {
                    color: "white"
                    height: 40
                    width: parent.width

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Text {
                            Layout.leftMargin: 10
                            text: model.display.name
                            color: "#B11030"
                            font.family: lato.name
                            font.pointSize: 12
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                        }
                        IconButton {
                            btnIconSource: "qrc:///assets/icon_play.svg"
                            Layout.preferredHeight: 40
                            Layout.preferredWidth: 30
                            Layout.alignment: Qt.AlignRight
                            onClicked: { quizzesModel.play(model.display) }
                        }
                        IconButton {
                            btnIconSource: "qrc:///assets/icon_edit.svg"
                            Layout.preferredHeight: 40
                            Layout.preferredWidth: 30
                            Layout.alignment: Qt.AlignRight
                            onClicked: { quizzesModel.edit(model.display) }
                        }
                        IconButton {
                            btnIconSource: "qrc:///assets/icon_delete.svg"
                            Layout.preferredHeight: 40
                            Layout.preferredWidth: 30
                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: 5
                            onClicked: {
                                var d = dialogDelete.createObject(homePage)
                                d.accepted.connect(function(){
                                    quizzesModel.delete(model.display)
                                })
                                d.rejected.connect(function(){})
                                d.visible = true
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: dialogDelete

        MessageDialog {
            title: "Brisanje kviza"
            text: "Sigurno želite obrisati ovaj kviz?"
            onVisibleChanged: if(!visible) destroy(1)
            // standardButtons: StandardButton.No | StandardButton.Yes
        }
    }
}
