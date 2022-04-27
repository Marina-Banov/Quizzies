import QtQuick
import QtQuick.Controls


Button {
    id: button
    property url btnIconSource
    flat: true
    down: false
    hoverEnabled: true
    icon.source: btnIconSource
    icon.color: "transparent"
    icon.width: button.height / 2
    icon.height: button.height / 2
    opacity: button.hovered ? 1 : .8
}
