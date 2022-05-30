import QtQuick
import QtQuick.Controls


Rectangle {
    id: treeDelegate
    implicitWidth: parent.width
    implicitHeight: 30
    /*
       TODO why is [0] allowed?
        Shouldn't this throw an IndexError if selection is empty?
    */
    color: treeViewSelection.selectedIndexes[0] == i ? Style.pinkVeryLight : "white"

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
                    treeViewSelection.select(i, ItemSelectionModel.ClearAndSelect);
                }
                categoriesTreeView.editableCategory = null;
            } else if (mouseEvent.button == 2 && type == "category") {
                categoriesTreeView.editableCategory = i;
            }
        }
    }

    Text {
        id: indicator
        visible: treeDelegate.isTreeNode && treeDelegate.hasChildren
        x: 8
        anchors.verticalCenter: editableLabel.verticalCenter
        text: "▸"
        font.pointSize: 12
        color: Style.red
        rotation: treeDelegate.expanded ? 90 : 0
    }

    Text {
        id: label
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: btnDelete.left
        anchors.leftMargin: { 10 + (treeDelegate.isTreeNode ? (treeDelegate.depth + 1) * treeDelegate.indent : 0) }
        verticalAlignment: Text.AlignVCenter
        clip: true
        text: name
        font.family: lato.name
        font.pointSize: 10
        color: Style.red
        visible: !editableLabel.visible
    }

    EditableText {
        id: editableLabel
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
        state: { (categoriesTreeView.editableCategory == i) ? "editing" : "" }
        onChangeAccepted: { categoriesModel.updateCategoryName(i, textValue) }
        onEndChange: { categoriesTreeView.editableCategory = null }
    }

    IconButton {
        id: btnAdd
        btnIconSource: "qrc:///assets/icon_add.svg"
        anchors.right: btnDelete.left
        height: parent.height
        width: 24
        visible: type == "category"
        onClicked: {}
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
                if (treeViewSelection.selectedIndexes[0] == i) {
                    treeViewSelection.clear();
                }
                categoriesModel.delete(id, type);
            });
            d.visible = 1;
        }
    }
}
