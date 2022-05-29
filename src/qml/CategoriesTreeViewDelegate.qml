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
    readonly property var i: categoriesModel.getElementIndex(id, type)

    // Assigned to by TreeView:
    required property TreeView treeView
    required property bool isTreeNode
    required property bool expanded
    required property int hasChildren
    required property int depth

    TapHandler {
        onTapped: {
            treeView.toggleExpanded(row)
            if (type == "question") {
                treeViewSelection.select(i, ItemSelectionModel.ClearAndSelect)
            }
        }
    }

    Text {
        id: indicator
        visible: treeDelegate.isTreeNode && treeDelegate.hasChildren
        x: 8
        // x: padding + (treeDelegate.depth * treeDelegate.indent)
        anchors.verticalCenter: label.verticalCenter
        text: "▸"
        font.pointSize: 12
        color: Style.red
        rotation: treeDelegate.expanded ? 90 : 0
    }

    Text {
        id: label
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        anchors.leftMargin: 10 + (treeDelegate.isTreeNode ?
        (treeDelegate.depth + 1) * treeDelegate.indent : 0)
        clip: true
        text: name
        font.family: lato.name
        font.pointSize: 10
        color: Style.red
    }

    IconButton {
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
            var d = dialogDelete.createObject(editPage)
            d.accepted.connect(function(){
                categoriesModel.delete(id, type)
            })
            d.rejected.connect(function(){})
            d.visible = true
        }
    }
}
