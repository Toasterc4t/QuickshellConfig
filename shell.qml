import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io



PanelWindow {

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

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property int ramUsage: 0
    property int storageUsage: 0
    property int gpuUsage: 0

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

    id: root 

    Process {
        id: gpuProc
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        stdout: SplitParser {
            onRead: data => gpuUsage = parseInt(data.trim())
    }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
                }
                lastCpuTotal = total
                lastCpuIdle = idle
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id : ramProc
        command: ["awk", "/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print int((t-a)/t*100)}", "/proc/meminfo"]
        stdout: SplitParser {
            onRead: data => {
                ramUsage = parseInt(data.trim())
        }
    }
    }

    Process {
    id: storageProc
    command: ["sh", "-c", "df --output=pcent /home | tail -1"]
    stdout: SplitParser {
        onRead: data => storageUsage = parseInt(data.trim())
    }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true, ramProc.running = true, gpuProc.running = true, storageProc.running = true
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
                }
            }
        

        Item {Layout.fillWidth: true }

        Text {
            text: "CPU: " + cpuUsage + "%   GPU: " + gpuUsage + "%  SSD: " + storageUsage + "%   RAM: " + ramUsage + "%"
            color: root.colYellow
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }

    }
}




