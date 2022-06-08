import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    function setFields(q) {
        // qtypeField.currentIndex = q["qtype"]-1;
        questionField.text = q["question"];
        nameField.text = q["name"];
        answerField.text = q["answer"];
        pointsField.text = q["points"];
    }

    function getFields() {
        return {
            // "qtype": qtypeField.text,
            "question": questionField.text,
            "name": nameField.text,
            "answer": answerField.text,
            "points": pointsField.text,
        }
    }

    function resetForm() {
        // qtypeField.currentIndex = 0;
        questionField.text = "";
        nameField.text = "";
        answerField.text = "";
        pointsField.text = "";
    }

    readonly property int elementWidth: 300
    columns: { Math.max(Math.floor((parent.width-30) / elementWidth), 1) }
    rows: { Math.max(Math.ceil(children.length / columns), 1) }
    Layout.fillHeight: true
    Layout.fillWidth: true
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
        Layout.preferredWidth: elementWidth
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
        Layout.preferredWidth: elementWidth
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
        Layout.preferredWidth: elementWidth
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
        Layout.preferredWidth: elementWidth
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
