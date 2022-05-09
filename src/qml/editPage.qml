import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
                GradientStop { position: .2; color: Style.pinkLight }
                GradientStop { position: .75; color: Style.pinkVeryLight }
            }
        }

        RowLayout {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            height: 60
            Layout.alignment: Qt.AlignVCenter

            RoundGradientButton {
                implicitWidth: 40
                icon.source: "qrc:///assets/icon_back.svg"
                icon.width: 18
                icon.height: 18
                onClicked: editPage.StackView.view.pop()
            }

            Text {
                // text: qsTr("Uredi kviz")
                text: "Uredi kviz"
                font.family: patuaOne.name
                font.pointSize: 24
                color: Style.redDark
            }

            Text {
                text: 'Ime kviza: ' + data.quiz?.name
                font.family: lato.name
                font.pointSize: 12
                color: Style.red
            }
        }

        Rectangle {
            anchors.top: topBar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 200
            color: "white"
            opacity: .8

            TreeView {
                id: categoriesTreeView
                model: categoriesModel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: bottomBar.top

                delegate: Rectangle {
                    id: treeDelegate
                    implicitWidth: parent.width
                    implicitHeight: 30

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
                        text: model.display
                        font.family: lato.name
                        font.pointSize: 10
                        color: Style.red
                    }

                    IconButton {
                        btnIconSource: "qrc:///assets/icon_delete.svg"
                        anchors.right: parent.right
                        height: parent.height
                        width: height
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
            }

            RowLayout {
                id: bottomBar
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                height: 30
                Layout.alignment: Qt.AlignVCenter

                RoundGradientButton {
                    implicitWidth: 80
                    implicitHeight: 30
                    // font.pointSize: 10
                    text: "SPREMI"
                }

                RoundGradientButton {
                    implicitWidth: 90
                    implicitHeight: 30
                    // font.pointSize: 10
                    text: "ISPROBAJ"
                }
            }
        }
    }
}
