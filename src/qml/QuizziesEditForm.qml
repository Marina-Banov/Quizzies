import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    function setFields(q) {
        // qtypeField.currentIndex = q["qtype"]-1;
        questionField.text = q["question"];
        nameField.text = q["name"];
        answerField.text = q["answer"];
        pointsField.text = q["points"];
    }

    function resetForm() {
        // qtypeField.currentIndex = 0;
        questionField.text = "";
        nameField.text = "";
        answerField.text = "";
        pointsField.text = "";
    }

    GridLayout {
        readonly property int elementWidth: 300
        columns: { Math.max(Math.floor(parent.width / elementWidth), 1) }
        rows: { Math.max(Math.ceil(children.length / columns), 1) }

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        rowSpacing: 15
        columnSpacing: rowSpacing

        /*ColumnLayout {
            Label {
                text: "Tip pitanja"
            }
            ComboBox {
                id: qtypeField
                Layout.fillWidth: true
                model: ["Tekst", "Slika", "Odabir"]
            }
        }*/

        ColumnLayout {
            Label {
                text: "Pitanje"
            }
            Flickable {
                Layout.fillWidth: true
                height: 80
                TextArea.flickable: TextArea {
                    id: questionField
                    wrapMode: Text.WordWrap
                    topPadding: 6
                    bottomPadding: 6
                    leftPadding: 8
                    rightPadding: 16
                }
                ScrollBar.vertical: ScrollBar {}
            }
        }

        ColumnLayout {
            Label {
                text: "Kratki opis pitanja  (" + nameField.length + '/' +
                nameField.maximumLength + " znakova)"
            }
            TextField {
                id: nameField
                Layout.fillWidth: true
                maximumLength: 30
                topPadding: 6
                bottomPadding: 6
                leftPadding: 8
                rightPadding: 8
            }
        }

        ColumnLayout {
            Label {
                text: "Točan odgovor"
            }
            TextField {
                id: answerField
                Layout.fillWidth: true
                topPadding: 6
                bottomPadding: 6
                leftPadding: 8
                rightPadding: 8
            }
        }

        RowLayout {
            Label {
                text: "Broj bodova"
            }
            TextField {
                id: pointsField
                Layout.leftMargin: 10
                Layout.fillWidth: true
                topPadding: 6
                bottomPadding: 6
                leftPadding: 8
                rightPadding: 8
                validator: DoubleValidator {
                    bottom: 0
                    decimals: 2
                    notation: DoubleValidator.StandardNotation
                    locale: "US"  // use decimal point
                }
            }
        }
    }
}
