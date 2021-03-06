import QtQuick
import QtQuick.Controls


Text {
    id: editableText

    property string textValue
    text: textValue

    signal changeAccepted
    signal endChange
    TextField {
        id: editor
        verticalAlignment: Text.AlignVCenter
        font.pointSize: editableText.font.pointSize
        anchors.fill: editableText
        text: textValue
        visible: false
        onAccepted: {
            if (text != textValue) {
                textValue = text;
                changeAccepted();
            }
            editingState.when = 0;
            endChange();
        }
    }

    property alias editingState: editingState
    states: State {
        id: editingState
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
}
