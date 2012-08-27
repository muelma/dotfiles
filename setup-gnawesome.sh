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
X-GNOME-WMName=Awesome
X-GNOME-Autostart-Phase=WindowManager
X-GNOME-Provides=windowmanager
X-GNOME-Autostart-Notify=false
EOF
cat << 'EOF' > /usr/share/xsessions/gnome-awesome.desktop
[Desktop Entry]
Name=gnawesome
Comment=Dynamic window manager
TryExec=/usr/bin/gnome-session
Exec=gnome-session --session awesome
Type=XSession
EOF
echo "login in your new session and type"
echo "> gsettings set org.gnome.desktop.background show-desktop-icons false"
echo "to disable right-clicking and gnome3 icons"
