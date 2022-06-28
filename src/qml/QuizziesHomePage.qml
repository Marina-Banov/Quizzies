import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform


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

        Column {
            anchors.fill: root
            anchors.topMargin: 90
            anchors.leftMargin: 50
            spacing: 25

            Text {
                width: 400
                wrapMode: Text.WordWrap
                text: "Dobrodošli u Quizzies!"
                font.family: merriweather.name
                font.pointSize: 38
                color: Style.redDark
            }

            Text {
                width: 500
                anchors.leftMargin: 5
                wrapMode: Text.WordWrap
                text: "Jeste li spremni za dobar provod s prijateljima?\nPokažite tko među vama zna odgovore na najteža pitanja i zabavite se!"
                font.family: lato.name
                font.pointSize: 14
                color: Style.red
            }

            Row {
                anchors.leftMargin: 5
                width: 500
                spacing: 25

                RoundGradientButton {
                    text: "NOVI KVIZ"
                    onClicked: {
                        var d = dialogCreate.createObject(homePage);
                        d.title = "Novi kviz";
                        d.label.text = "Ime kviza";
                        d.accepted.connect(() => {
                            if (quizzesModel.create(d.nameField.text)) {
                                quizzesModel.details(0);
                                internals.currentQuizIndex = quizzesModel.index(0,0);
                                stack.push("QuizziesEditPage.qml");
                            }
                        });
                        d.visible = 1;
                    }
                }

                RoundGradientButton {
                    visible: root.width < 828
                    text: "ODABERI KVIZ"
                    onClicked: { animationMenu.running = true }
                }
            }

            Text {
                width: 500
                anchors.leftMargin: 5
                wrapMode: Text.WordWrap
                text: "Ovdje možete <a href='load'>učitati</a> ili <a href='save'>spremiti</a> bazu pitanja u JSON formatu."
                font.family: lato.name
                font.pointSize: 11
                color: Style.red
                onLinkActivated: (link) => {
                    if (link == "save") {
                        saveDialog.open()
                    } else {
                        loadDialog.open()
                    }
                }
            }
        }

        FileDialog {
            id: loadDialog
            nameFilters: ["JSON (*.json)"]
            folder: { StandardPaths.writableLocation("") }
            onAccepted: { folder = quizzesModel.load(currentFile) }
        }

        FileDialog {
            id: saveDialog
            currentFile: "Quizzies_db.json"
            nameFilters: ["JSON (*.json)"]
            folder: { StandardPaths.writableLocation("") }
            fileMode: FileDialog.SaveFile
            onAccepted: { folder = quizzesModel.save(currentFile) }
        }

        Rectangle {
            id: menu
            width: { (root.width >= 828) ? 300 : 0 }
            height: parent.height
            color: Style.whiteOpacity
            anchors.right: parent.right

            PropertyAnimation {
                id: animationMenu
                target: menu
                Component.onCompleted: property = "width"
                to: { if(menu.width == 0) return 200 }
                duration: 400
                easing.type: Easing.InOutQuint
            }

            ListView {
                anchors.fill: parent
                model: quizzesModel
                delegate: QuizziesListViewDelegate {}
            }
        }
    }
}
