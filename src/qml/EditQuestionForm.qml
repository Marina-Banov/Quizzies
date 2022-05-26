import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15

        Label {
            text: "Tip pitanja"
        }

        ComboBox {
            Layout.fillWidth: true
            model: ["Tekst", "Slika", "Odabir"]
        }

        Label {
            text: "Pitanje"
        }

        TextArea {
            placeholderText: "unesi pitanje!"
            Layout.fillWidth: true
            topPadding: 6
            bottomPadding: 6
            leftPadding: 8
            rightPadding: 8
        }

        Label{
            text: "Točan odgovor"
        }

        TextArea {
            placeholderText: "unesi odgovor!"
            Layout.fillWidth: true
            topPadding: 6
            bottomPadding: 6
            leftPadding: 8
            rightPadding: 8
        }

        RowLayout {
            Label {
                text: "Broj bodova"
            }

            TextField {
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
