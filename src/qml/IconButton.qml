import QtQuick
import QtQuick.Controls


Button {
    property url btnIconSource
    flat: true
    down: false
    hoverEnabled: true
    icon.source: btnIconSource
    icon.color: "transparent"
    icon.width: height / 2
    icon.height: height / 2
    opacity: hovered ? 1 : .8
}
