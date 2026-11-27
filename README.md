# QuickshellConfig
Personal config to learn Quickshell and QML, design based on the game signalis.

# To do list :
- media visualizer matching the game's radio pannel
- app launcher matching the memory pannel
- something to match the diagnostics pannel; maybe use the cpu/gpu/ram/ssd usage currently shown in the top bar.
- volume indicator in the bar.

reorganize every folder and files to a more professional and clear configuration.

Signalis-shell/
├── shell.qml              # point d'entrée, quasi vide
├── README.md
├── .gitignore
├── assets/                # polices, icônes, sons
├── config/
│   └── Theme.qml          # singleton : couleurs, polices, tailles Signalis
├── services/              # singletons : données, aucune UI
│   ├── SysStats.qml       # CPU / RAM / GPU / SSD / températures
│   ├── Media.qml          # lecteur média (pour la radio)
│   ├── Audio.qml          # volume
│   └── Time.qml
├── components/            # petites briques réutilisables
│   ├── Panel.qml          # cadre style Signalis
│   ├── StatBar.qml
│   └── ...
├── modules/               # un dossier par "écran" du shell
│   ├── bar/               # Bar.qml, Workspaces.qml, Clock.qml, VolumeIndicator.qml
│   ├── launcher/          # Launcher.qml (panneau mémoire)
│   ├── radio/             # Radio.qml, Visualizer.qml (panneau radio)
│   └── diagnostics/       # Diagnostics.qml (ton sys_status actuel)
└── scripts/               # scripts shell/python (ex. usage GPU)