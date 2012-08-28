#!/bin/bash
cat << 'EOF' > /usr/share/gnome-session/sessions/awesome.session
[GNOME Session]
Name=Awesome session
RequiredComponents=gnome-settings-daemon;
RequiredProviders=windowmanager;
DefaultProvider-windowmanager=awesome
DesktopName=GNOME
EOF
#RequiredProviders=windowmanager;notifications;
#DefaultProvider-notifications=notification-daemon
cat << 'EOF' > /usr/share/applications/awesome.desktop
[Desktop Entry] 
Encoding=UTF-8
Name=awesome
Type=Application
Comment=Highly configurable framework window manager
TryExec=awesome
Exec=awesome
NoDisplay=true
X-GNOME-WMSettingsModule=awesome
# name we put on the WM spec check window
X-GNOME-WMName=Awesome
X-GNOME-Autostart-Phase=WindowManager;Panel
X-GNOME-Provides=windowmanager;panel
X-GNOME-AutoRestart=true
X-GNOME-Autostart-Notify=true
EOF
cat << 'EOF' > /usr/share/xsessions/gnome-awesome.desktop
[Desktop Entry]
Name=gnawesome
Comment=Dynamic window manager
TryExec=/usr/bin/gnome-session
Exec=gnome-session --session awesome
Type=XSession
EOF
echo "you might consider using gsetter.sh for disabling the desktop/icons"
echo "and some other stuff that is not needed from gnome"
