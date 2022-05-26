import QtQuick
import QtQuick.Controls


Rectangle {
    id: treeDelegate
    implicitWidth: parent.width
    implicitHeight: 30
    color: "white"

    readonly property real indent: 15
    readonly property real padding: 20

    // Assigned to by TreeView:
    required property TreeView treeView
    required property bool isTreeNode
    required property bool expanded
    required property int hasChildren
    required property int depth

    TapHandler {
        onTapped: treeView.toggleExpanded(row)
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
        text: model.name
        font.family: lato.name
        font.pointSize: 10
        color: Style.red
    }

    IconButton {
        btnIconSource: "qrc:///assets/icon_add.svg"
        anchors.right: btnDelete.left
        height: parent.height
        width: 24
        visible: model.type == "category"
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
                categoriesModel.delete(model.id, model.type)
            })
            d.rejected.connect(function(){})
            d.visible = true
        }
    }
}
