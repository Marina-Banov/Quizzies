import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects


Page {
    id: editPage

    QtObject {
        id: data
        property var quiz: quizzesModel.data(quizzesModel.index(internals.currentIndex, 0), Qt.DispalyRole)
    }

    Rectangle {
        id: root
        anchors.fill: parent

        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.2; color: "#FFF3F3" }
                GradientStop { position: 0.75; color: "#FFC8DC" }
            }
        }

        Text {
            id: title
            width: 400
            x: 50; y: 90
            wrapMode: Text.WordWrap
            // text: qsTr("Dobrodošli u Quizzies!")
            text: "Edit page?"
            font.family: patuaOne.name
            font.pointSize: 44
            color: "#880d26"
        }

        Text {
            text: 'Name: ' + data.quiz?.name
            font.pointSize: 20
        }

        RoundGradientButton {
            anchors.topMargin: 25
            anchors.top: title.bottom
            anchors.left: title.left
            // text: qsTr("GO BACK")
            text: "GO BACK"
            onClicked: editPage.StackView.view.pop()
        }

        TreeView {
            id: categoriesTreeView
            model: categoriesModel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 260

            delegate: Item {
                id: treeDelegate

                implicitWidth: padding + label.x + label.implicitWidth + padding
                implicitHeight: label.implicitHeight * 1.5

                readonly property real indent: 20
                readonly property real padding: 5

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
                    x: padding + (treeDelegate.depth * treeDelegate.indent)
                    anchors.verticalCenter: label.verticalCenter
                    text: "▸"
                    rotation: treeDelegate.expanded ? 90 : 0
                }

                Text {
                    id: label
                    x: padding + (treeDelegate.isTreeNode ? (treeDelegate.depth + 1) * treeDelegate.indent : 0)
                    width: treeDelegate.width - treeDelegate.padding - x
                    clip: true
                    text: model.display
                }
            }
        }
    }
}
