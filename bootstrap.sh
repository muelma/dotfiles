#!/bin/bash
#!/usr/bin/env bash
#
# Creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#

# variables
CONFIG_FILE="config.list"
BACKUP_FILE=$HOME/dotfiles_backup.tgz   # name for the backup file (uses tar)
SCRIPT_PATH=`pwd`

# ask for backup
echo "Create a backup of the dotfiles in your home directory? y/n/A(bort):"
read ANSWER
if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]
then
    # create a backup
    # read targets from config.list
    BACKUP_FILELIST=""
    while read TARGET SYMLINK 
    do
        # evaluate the symlink name (if ~ or $HOME is used in config.list)
        SYMLINK_E=`eval echo "$SYMLINK"`
        if [ -e "$SYMLINK_E" ] ; then
            BACKUP_FILELIST="$BACKUP_FILELIST $SYMLINK_E"
        fi
    done < "$CONFIG_FILE"
    # Actual backup
    echo "Creating backup of dotfiles in $HOME as $BACKUP_FILE"
    # strip home path with sed from the filename and tar from home directory
    # this way the filenames are stored relative to the home directory
    echo "$BACKUP_FILELIST" | sed "s.$HOME/..g" | xargs tar --directory="$HOME" -c -h -z -f "$BACKUP_FILE"
elif [[ "$ANSWER" == "n" || "$ANSWER" == "N" ]]
then
# omit backup
    echo "Omitting backup."
else
    echo "Aborting."
    exit 1
fi

echo "Symlinking dotfiles:"
while read TARGET SYMLINK 
do
    # evaluate the symlink name (if ~ or $HOME is used in config.list)
    SYMLINK_E=`eval echo "$SYMLINK"`
    if [ -d "$SYMLINK_E" ]; then
        rm -rf "$SYMLINK_E"
    fi
    TARGET_FULL="$SCRIPT_PATH/$TARGET"
    echo "installing $SYMLINK_E -> $TARGET_FULL"
    ln -snf "$TARGET_FULL" "$SYMLINK_E"
done < "$CONFIG_FILE"
