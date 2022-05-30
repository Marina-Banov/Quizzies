import QtQuick
import QtQuick.Controls


Text {
    id: editableText

    property string textValue
    text: textValue

    function onChangeAccepted() {}

    TextField {
        id: editor
        verticalAlignment: Text.AlignVCenter
        font.pointSize: editableText.font.pointSize
        anchors.fill: editableText
        text: textValue
        visible: false
        onAccepted: {
            textValue = text
            editableText.state = ""
            onChangeAccepted()
        }
    }

    states: [
        State {
            name: "editing"
            PropertyChanges {
                target: editor
                focus: true
                visible: true
            }
            PropertyChanges {
                target: editableText
                explicit: true
                restoreEntryValues: false
            }
        }
    ]
}
