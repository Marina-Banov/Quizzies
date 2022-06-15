import QtQuick
import QtQuick.Controls


Rectangle {
    implicitWidth: parent.width
    implicitHeight: 30
    /*
       TODO why is [0] allowed?
        Shouldn't this throw an IndexError if selection is empty?
    */
    color: selection.selectedIndexes[0] == i ? Style.pinkLight : "white"

    readonly property real indent: 15
    readonly property real padding: 20
    property var i: { categoriesModel.getElementIndex(id, type) }

    // Assigned to by TreeView:
    required property TreeView treeView
    required property bool isTreeNode
    required property bool expanded
    required property int hasChildren
    required property int depth

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouseEvent) => {
            if (mouseEvent.button == 1) {
                treeView.toggleExpanded(row);
                if (type == "question") {
                    selection.select(i, ItemSelectionModel.ClearAndSelect);
                }
                categoriesTreeView.editableCategory = null;
            } else if (mouseEvent.button == 2 && type == "category") {
                categoriesTreeView.editableCategory = i;
                // TODO this part is still a little buggy :c
            }
        }
    }

    Text {
        visible: isTreeNode && hasChildren
        x: 8
        anchors.verticalCenter: parent.verticalCenter
        text: "▸"
        font.pointSize: 12
        color: Style.red
        rotation: expanded ? 90 : 0
    }

    Text {
        id: label
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: btnDelete.left
        anchors.leftMargin: { 10 + (isTreeNode ? (depth + 1) * indent : 0) }
        verticalAlignment: Text.AlignVCenter
        clip: true
        text: name
        font.family: lato.name
        font.pointSize: 10
        color: Style.red
        visible: type != "category"
    }

    EditableText {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: btnAdd.left
        anchors.leftMargin: label.anchors.leftMargin
        verticalAlignment: Text.AlignVCenter
        clip: true
        textValue: name
        font: label.font
        color: Style.red
        visible: type == "category"
        editingState.when: { categoriesTreeView.editableCategory == i }
        onChangeAccepted: { categoriesModel.updateCategory(i, textValue) }
        onEndChange: { categoriesTreeView.editableCategory = null }
    }

    IconButton {
        id: btnAdd
        btnIconSource: "qrc:///assets/icon_add.svg"
        anchors.right: btnDelete.left
        height: parent.height
        width: 24
        visible: type == "category"
        onClicked: {
            var d = dialogCreate.createObject(editPage);
            d.title = "Novo pitanje";
            d.nameField.maximumLength = 30;
            d.nameField.textEdited.connect(() => {
                d.label.text = "Kratki opis pitanja (%1/%2)"
                    .arg(d.nameField.length).arg(30);
            })
            d.nameField.textEdited();
            d.accepted.connect(() => {
                var res = categoriesModel.createQuestion(d.nameField.text, i);
                if (res.valid) {
                    treeView.expand(row);
                    selection.select(res, ItemSelectionModel.ClearAndSelect);
                }
            });
            d.visible = 1;
        }
    }

    IconButton {
        id: btnDelete
        btnIconSource: "qrc:///assets/icon_delete.svg"
        anchors.right: parent.right
        height: parent.height
        width: 24
        onClicked: {
            var d = dialogDelete.createObject(editPage);
            d.accepted.connect(() => {
                if (selection.selectedIndexes[0] == i) {
                    selection.clear();
                }
                categoriesModel.delete(id, type);
            });
            d.visible = 1;
        }
    }
}
