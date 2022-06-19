import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Page {
    id: editPage

    Rectangle {
        id: root
        anchors.fill: parent

        Image {
            id: background
            fillMode: Image.PreserveAspectCrop
            anchors.fill: root
            source: "qrc:///assets/bg2.png"
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
                onClicked: {
                    selection.clear();
                    form.resetForm();
                    internals.currentQuizIndex = null;
                    stack.pop();
                }
            }

            Text {
                text: "Uredi kviz"
                font.family: merriweather.name
                font.pointSize: 20
                color: Style.redDark
            }

            EditableText {
                id: quizNameField
                textValue: {
                    if (internals.currentQuizIndex)
                        return quizzesModel.data(internals.currentQuizIndex)
                    ""
                }
                font.family: lato.name
                font.pointSize: 12
                color: Style.red
                padding: 8

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: { quizNameField.editingState.when = true }
                }

                onChangeAccepted: {
                    quizzesModel.update(internals.currentQuizIndex, textValue)
                }
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
                    contentWidth: menu.width
                    selectionModel: ItemSelectionModel {
                        id: selection
                        model: categoriesModel
                    }
                    property var editableCategory: null
                    delegate: QuizziesTreeViewDelegate {}
                }

                RoundGradientButton {
                    anchors.top: categoriesTreeView.bottom
                    anchors.right: parent.right
                    anchors.margins: 10
                    implicitWidth: 140
                    implicitHeight: 25
                    font.pointSize: 9
                    text: "NOVA KATEGORIJA"
                    onClicked: {
                        var d = dialogCreate.createObject(editPage);
                        d.title = "Nova kategorija";
                        d.label.text = "Ime kategorije";
                        d.accepted.connect(() => {
                            categoriesModel.createCategory(d.nameField.text)
                        });
                        d.visible = 1;
                    }
                }
            }

            ColumnLayout {
                visible: selection.hasSelection
                Layout.margins: 15
                Layout.alignment: Qt.AlignTop
                spacing: 15
                QuizziesEditForm { id: form }
                RoundGradientButton {
                    Layout.alignment: Qt.AlignRight
                    implicitWidth: 70
                    implicitHeight: 25
                    font.pointSize: 9
                    text: "SPREMI"
                    onClicked: {
                        var i = selection.selectedIndexes[0];
                        categoriesModel.updateQuestion(i, form.getFields());
                    }
                }
            }
        }
    }
}
