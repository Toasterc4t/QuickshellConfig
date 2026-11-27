pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property int ramUsage: 0
    property int storageUsage: 0
    property int gpuUsage: 0

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
}

