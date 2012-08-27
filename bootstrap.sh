#!/usr/bin/env bash
#
# Creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#

# Variables
DIR=$HOME/dotfiles                      # dotfiles directory
BACKUP_FILE=$HOME/dotfiles_backup.tgz   # name for the backup file (uses tar)
THISDIR=$(pwd)
TEMP_TAR=$THISDIR/temp_dotfiles.tar

OLDDIR=$HOME/dotfiles.old   # old dotfiles backup directory
# find files living in this directory, excluding shell scripts (*.sh) and the .git directory
FILES=$(find . -type f | grep -v ".sh$" | grep -v ".git")

BACKUP_THESE=""
for x in $FILES; do
    # backup files in $HOME directory
    if [ -e $HOME/$x ]; then
        BACKUP_THESE="$BACKUP_THESE $x"
    fi
done

if [ -e $BACKUP_FILE ]; then
    echo "Warning: backup file $BACKUP_FILE exists. Overwrite (y/n)?"
    read ANSWER
    if [[ $ANSWER != "y" && $ANSWER != "Y" ]]; then
        echo "Aborting."
        exit 1
    fi
fi

echo Creating backup of dotfiles in $HOME as $BACKUP_FILE
cd $HOME && echo $BACKUP_THESE | xargs tar czf $BACKUP_FILE
echo Copying dotfiles in $THISDIR to $HOME
cd $THISDIR
#echo "$FILES" | xargs -I{} cp -f "$THISDIR/{}" "$HOME/{}"
echo $FILES | xargs tar cf $TEMP_TAR && tar xf $TEMP_TAR -C $HOME
rm $TEMP_TAR
