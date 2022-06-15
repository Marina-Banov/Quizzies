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
                onClicked: { stack.pop() }
            }

            Text {
                text: "Uredi kviz"
                font.family: patuaOne.name
                font.pointSize: 24
                color: Style.redDark
            }

            EditableText {
                id: quizNameField
                textValue: { quizzesModel.data(internals.currentQuizIndex) }
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
                    selectionModel: ItemSelectionModel {
                        id: selection
                        model: categoriesModel
                        onSelectionChanged: {
                            if (hasSelection) {
                                var q = categoriesModel.itemData(selectedIndexes[0]);
                                form.setFields(q);
                            } else {
                                form.resetForm();
                            }
                        }
                    }
                    property var editableCategory: null
                    delegate: QuizziesTreeViewDelegate {}
                }

                RoundGradientButton {
                    anchors.top: categoriesTreeView.bottom
                    anchors.right: parent.right
                    anchors.margins: 10
                    implicitWidth: 130
                    implicitHeight: 25
                    font.pointSize: 10
                    text: "NOVA KATEGORIJA"
                    onClicked: {
                        var d = dialogCreate.createObject(editPage);
                        d.title = "Nova kategorija";
                        d.label.text = "Ime kategorije";
                        d.accepted.connect(() => {
                            // TODO bug with the first category
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
                    implicitWidth: 80
                    implicitHeight: 25
                    font.pointSize: 10
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
