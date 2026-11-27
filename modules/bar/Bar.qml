import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.config
import qs.services

PanelWindow {
    id: root 

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: Theme.colBg

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "dd/MM/yyyy") + "   achtung    " + Qt.formatDateTime(clock.date, "HH:mm:ss")
        color: Theme.colTxt
        font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        
        Repeater {
            model: 9

            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 10
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                color: isActive ? Theme.colWhite : (ws ? Theme.colRed : Theme.colGrey)
                border.width: (!isActive && !ws) ? 2 : 0
                border.color: Theme.colBorder
                MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
                    }
                }
            }
        

        Item {Layout.fillWidth: true }

        Text {
            text: "CPU: " + SysStats.cpuUsage + "%   GPU: " + SysStats.gpuUsage + "%  SSD: " + SysStats.storageUsage + "%   RAM: " + SysStats.ramUsage + "%"
            color: Theme.colYellow
            font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
        }

    }
}




