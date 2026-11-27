import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.services


PanelWindow {
    id: root 

    property color colBg: "#1a1b26"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property color colDBlue: "#444b6a"
    property color colTxt: "#a9b1d6"
    property color colRed: "#c3420b"
    property color colWhite: '#ffffff'
    property color colGrey: '#212221'
    property color colBorder: '#605560'


    property string fontFamily: "Visitor TT2 BRK"

    property int fontSize: 20


    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: colBg

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "dd/MM/yyyy") + "   achtung    " + Qt.formatDateTime(clock.date, "HH:mm:ss")
        color: colTxt
        font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
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
                color: isActive ? colWhite : (ws ? colRed : colGrey)
                border.width: (!isActive && !ws) ? 2 : 0
                border.color: colBorder
                MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
                    }
                }
            }
        

        Item {Layout.fillWidth: true }

        Text {
            text: "CPU: " + SysStats.cpuUsage + "%   GPU: " + SysStats.gpuUsage + "%  SSD: " + SysStats.storageUsage + "%   RAM: " + SysStats.ramUsage + "%"
            color: root.colYellow
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }

    }
}




