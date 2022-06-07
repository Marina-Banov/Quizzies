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

        Rectangle {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            color: "transparent"

            RoundGradientButton {
                id: btnBack
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: implicitHeight
                icon.source: "qrc:///assets/icon_back.svg"
                icon.width: 18
                icon.height: 18
                onClicked: { playPage.StackView.view.pop() }
            }

            Text {
                //anchors.left: btnBack.right
                //anchors.right: parent.right
                //anchors.leftMargin: 20
                //horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: { quizzesModel.data(internals.currentQuizIndex) }
                font.family: patuaOne.name
                font.pointSize: 24
                color: Style.redDark
            }
        }

        TreeView {
            id: playTreeView
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

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: topBar.height
            anchors.bottomMargin: bottomBar.height
            color: "transparent"
            Connections {
                target: selection
                function onSelectionChanged() {
                    var s = selection.selectedIndexes[0];
                    label.model = categoriesModel.itemData(s)
                }
            }
            Text {
                id: label
                property var model: null
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: model.type + ": " + model.name
                font.family: lato.name
                font.pointSize: 14
                color: Style.red
            }
        }

        Rectangle {
            id: bottomBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 60
            anchors.rightMargin: 60
            height: 60
            color: "transparent"

            RoundGradientButton {
                id: btnPrev
                anchors.left: parent.left
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

            RoundGradientButton {
                id: btnNext
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: implicitHeight
                icon.source: "qrc:///assets/icon_back.svg"
                icon.width: 18
                icon.height: 18
                transform: Scale {
                    xScale: -1
                    origin.x: btnNext.width/2
                    origin.y: btnNext.height/2
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
