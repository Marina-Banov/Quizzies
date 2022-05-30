import QtQuick
import QtQuick.Controls


Button {
    id: iconButton
    property url btnIconSource
    flat: true
    down: false
    hoverEnabled: true
    icon.source: btnIconSource
    icon.color: "transparent"
    icon.width: iconButton.height / 2
    icon.height: iconButton.height / 2
    opacity: iconButton.hovered ? 1 : .8
}
