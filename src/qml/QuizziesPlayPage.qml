import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Page {
    id: playPage

    Rectangle {
        id: root
        anchors.fill: parent

        RadialGradient {
            id: background
            anchors.fill: root
            gradient: Gradient {
                GradientStop { position: .2; color: Style.pinkVeryLight }
                GradientStop { position: .75; color: Style.pinkLight }
            }
        }

        RowLayout {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60

            RoundGradientButton {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 20
                implicitWidth: implicitHeight
                icon.source: "qrc:///assets/icon_back.svg"
                icon.width: 18
                icon.height: 18
                onClicked: { stack.pop() }
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                text: { quizzesModel.data(internals.currentQuizIndex) }
                font.family: patuaOne.name
                font.pointSize: 24
                color: Style.redDark
            }
        }

        TreeView {
            model: categoriesModel
            selectionModel: ItemSelectionModel {
                id: selection
                model: categoriesModel
            }
            Component.onCompleted: {
                var first = categoriesModel.index(0, 0);
                selection.select(first, ItemSelectionModel.ClearAndSelect);
            }
        }

        Text {
            property var model: {
                if (!selection.hasSelection) return
                categoriesModel.itemData(selection.selectedIndexes[0])
            }
            anchors.fill: parent
            anchors.margins: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: {
                if (!model) return ""
                if (model.type == "category") return "Kategorija " + model.name
                model.order + '. ' + model.question
            }
            font.family: {
                if (model && model.type == "category") return patuaOne.name
                lato.name
            }
            font.pointSize: { (model && model.type == "category") ? 18 : 14 }
            color: Style.red
            wrapMode: Text.WordWrap
        }

        RowLayout {
            id: bottomBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RoundGradientButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: implicitHeight
                    icon.source: "qrc:///assets/icon_back.svg"
                    icon.width: 18
                    icon.height: 18
                    onClicked: {
                        var i = selection.selectedIndexes[0];
                        var prev = categoriesModel.prev(i);
                        if (prev != i)
                            selection.select(prev, ItemSelectionModel.ClearAndSelect);
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RoundGradientButton {
                    id: btnNext
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: implicitHeight
                    icon.source: "qrc:///assets/icon_back.svg"
                    icon.width: 18
                    icon.height: 18
                    transform: Scale {
                        xScale: -1
                        origin.x: btnNext.width / 2
                        origin.y: btnNext.height / 2
                    }
                    onClicked: {
                        var i = selection.selectedIndexes[0];
                        var next = categoriesModel.next(i);
                        if (next != i)
                            selection.select(next, ItemSelectionModel.ClearAndSelect);
                    }
                }
            }
        }
    }
}
