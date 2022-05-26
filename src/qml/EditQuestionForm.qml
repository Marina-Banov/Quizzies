import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        spacing: 15

        ColumnLayout {
            Label {
                text: "Tip pitanja"
            }
            ComboBox {
                Layout.fillWidth: true
                model: ["Tekst", "Slika", "Odabir"]
            }
        }

        ColumnLayout {
            Label {
                text: "Pitanje"
            }
            Flickable {
                Layout.fillWidth: true
                height: 80
                // contentWidth: width
                // contentHeight: textArea.implicitHeight
                TextArea.flickable: TextArea {
                    wrapMode: Text.WordWrap
                    topPadding: 6
                    bottomPadding: 6
                    leftPadding: 8
                    rightPadding: 8
                }
                ScrollBar.vertical: ScrollBar {}
            }
        }

        ColumnLayout {
            Label {
                text: "Kratki opis pitanja  (" + shortCode.length + '/' +
                shortCode.maximumLength + " znakova)"
            }
            TextField {
                id: shortCode
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
