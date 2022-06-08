import QtQuick
import QtQuick.Controls
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
            color: Style.redDark
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
            color: Style.red
        }

        Row {
            anchors.topMargin: 25
            anchors.top: textDescription.bottom
            anchors.left: textDescription.left
            width: textDescription.width
            spacing: 25

            RoundGradientButton {
                // text: qsTr("NOVI KVIZ")
                text: "NOVI KVIZ"
                onClicked: {
                    var d = dialogCreate.createObject(homePage);
                    d.title = "Novi kviz";
                    d.placeholder = "Ime kviza";
                    d.accepted.connect(() => {
                        if (quizzesModel.create(d.name)) {
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
                // text: qsTr("ODABERI KVIZ")
                text: "ODABERI KVIZ"
                onClicked: { animationMenu.running = true }
            }
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
