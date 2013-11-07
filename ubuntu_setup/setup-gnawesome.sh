#!/bin/bash
cat << 'EOF' > /usr/share/gnome-session/sessions/awesome.session
[GNOME Session]
Name=Awesome session
RequiredComponents=awesome;gnome-settings-daemon;
RequiredProviders=windowmanager;
DefaultProvider-windowmanager=awesome
DesktopName=GNOME
EOF
cat << 'EOF' > /usr/share/applications/awesome.desktop
[Desktop Entry] 
Encoding=UTF-8
Name=awesome
Type=Application
Comment=Highly configurable framework window manager
TryExec=awesome
Exec=awesome
NoDisplay=true
EOF
cat << 'EOF' > /usr/share/xsessions/awesome-gnome.desktop
[Desktop Entry]
Name=Awesome GNOME
Comment=Dynamic window manager
Exec=gnome-session --session=awesome
TryExec=awesome
Type=Application
X-LightDM-DesktopName=Awesome GNOME
X-Ubuntu-Gettext-Domain=gnome-session-3.0
EOF
cp custom_awesome_badge.png /usr/share/unity-greeter/custom_gnome-awesome_badge.png
echo "you might consider using gsetter.sh for disabling the desktop/icons"
echo "and some other stuff that is not needed from gnome"
