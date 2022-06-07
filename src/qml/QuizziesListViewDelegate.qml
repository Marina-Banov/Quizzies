import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    color: "white"
    height: 40
    width: menu.width

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Text {
            Layout.leftMargin: 10
            text: name
            color: Style.red
            font.family: lato.name
            font.pointSize: 12
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }

        IconButton {
            btnIconSource: "qrc:///assets/icon_play.svg"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight
            onClicked: {
                quizzesModel.details(index);
                internals.currentQuizIndex = quizzesModel.index(index, 0);
                stack.push("QuizziesPlayPage.qml");
            }
        }

        IconButton {
            btnIconSource: "qrc:///assets/icon_edit.svg"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight
            onClicked: {
                quizzesModel.details(index);
                internals.currentQuizIndex = quizzesModel.index(index, 0);
                stack.push("QuizziesEditPage.qml");
            }
        }

        IconButton {
            btnIconSource: "qrc:///assets/icon_delete.svg"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 5
            onClicked: {
                var d = dialogDelete.createObject(homePage);
                d.accepted.connect(() => quizzesModel.delete(index));
                d.visible = 1;
            }
        }
    }
}
