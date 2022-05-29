import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Page {
    id: editPage

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
                text: quizzesModel.data(internals.currentQuizIndex)
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
                color: Style.whiteOpacity

                TreeView {
                    id: categoriesTreeView
                    model: categoriesModel
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: contentHeight
                    selectionModel: ItemSelectionModel {
                        id: treeViewSelection
                        model: categoriesModel
                        onSelectionChanged: {
                            var q = categoriesModel.itemData(selectedIndexes[0])
                            form.setFields(q)
                        }
                    }
                    delegate: CategoriesTreeViewDelegate {}
                }

                RoundGradientButton {
                    id: btnNewCategory
                    anchors.top: categoriesTreeView.bottom
                    anchors.right: parent.right
                    anchors.margins: 10
                    implicitWidth: 130
                    implicitHeight: 25
                    font.pointSize: 10
                    text: "NOVA KATEGORIJA"
                }
            }

            EditQuestionForm {
                id: form
                visible: treeViewSelection.hasSelection
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
