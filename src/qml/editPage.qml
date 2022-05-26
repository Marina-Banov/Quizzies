import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Page {
    id: editPage

    QtObject {
        id: data
       // property var quiz: quizzesModel.data(quizzesModel.index(internals
       // .currentIndex, 0))
    }

    Rectangle {
        id: root
        anchors.fill: parent

        RadialGradient {
            id: background
            anchors.fill: root
            gradient: Gradient {
                GradientStop { position: .2; color: Style.pinkVeryLight }
                GradientStop { position: .75; color: Style.pinkLight }
            }
        }

        RowLayout {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            height: 60
            Layout.alignment: Qt.AlignVCenter

            RoundGradientButton {
                implicitWidth: implicitHeight
                icon.source: "qrc:///assets/icon_back.svg"
                icon.width: 18
                icon.height: 18
                onClicked: editPage.StackView.view.pop()
            }

            Text {
                // text: qsTr("Uredi kviz")
                text: "Uredi kviz"
                font.family: patuaOne.name
                font.pointSize: 24
                color: Style.redDark
            }

            Text {
                text: 'Ime kviza: ' + data.quiz?.name
                font.family: lato.name
                font.pointSize: 12
                color: Style.red
            }
        }

        RowLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topBar.bottom

            Rectangle {
                id: menu
                Layout.fillHeight: true
                width: 200
                color: "white"
                opacity: .8

                TreeView {
                    id: categoriesTreeView
                    model: categoriesModel
                    anchors.fill: parent
                    anchors.bottom: bottomBar.top
                    delegate: CategoriesTreeViewDelegate {}
                }

                RowLayout {
                    id: bottomBar
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: 30
                    Layout.alignment: Qt.AlignVCenter

                    RoundGradientButton {
                        implicitWidth: 90
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignHCenter
                        // font.pointSize: 10
                        text: "ISPROBAJ"
                    }
                }
            }

            EditQuestionForm {
                id: form
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
