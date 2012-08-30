#!/usr/bin/env bash
#
# Creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#

# Variables
DIR=$HOME/dotfiles                      # dotfiles directory
BACKUP_FILE=$HOME/dotfiles_backup.tgz   # name for the backup file (uses tar)
THISDIR=$(pwd)

OLDDIR=$HOME/dotfiles.old   # old dotfiles backup directory
# find files living in this directory, excluding shell scripts (*.sh) and the .git directory
# and README.md
FILES=$(find . -type f | grep -v ".sh$" | grep -v ".git" | grep -v "README.md" | grep -v ".png" )

BACKUP_THESE=""
for x in $FILES; do
    # backup files in $HOME directory
    if [ -e $HOME/$x ]; then
        BACKUP_THESE="$BACKUP_THESE $x"
    fi
done

MAKE_BACKUP=0
# look if there are files to be saved
if [[ $BACKUP_THESE == "" ]]
then
    MAKE_BACKUP=1
    echo "Omitting backup (Nothing to store)."
fi
# in case the backup file already exists, can it be overwritten?
if [[ -e $BACKUP_FILE && $MAKE_BACKUP == 0 ]]
then
    echo "Warning: backup file $BACKUP_FILE exists. Overwrite? y/n/A(bort):"
    read ANSWER
    if [[ $ANSWER == "y" || $ANSWER == "Y" ]]
    then
        MAKE_BACKUP=0
    elif [[ $ANSWER == "n" || $ANSWER == "N" ]]
    then
        MAKE_BACKUP=1
        echo Omitting backup.
    else
        echo Aborting.
        exit 1
    fi
fi

if [[ $MAKE_BACKUP == 0 ]]
then
    echo Creating backup of dotfiles in $HOME as $BACKUP_FILE
    cd $HOME && echo $BACKUP_THESE | xargs tar czf $BACKUP_FILE
fi

#echo Copying dotfiles in $THISDIR to $HOME
#TEMP_TAR=$THISDIR/temp_dotfiles.tar
#cd $THISDIR && echo $FILES | xargs tar cf $TEMP_TAR && tar xf $TEMP_TAR -C $HOME && rm $TEMP_TAR
echo Symlinking dotfiles
for x in $FILES;
do
    DIRECTORY=`dirname $HOME/$x`
    if [ ! -d "$DIRECTORY" ]
    then
        mkdir -p "$DIRECTORY" 
    fi
    ln -sf "$THISDIR/$x" "$HOME/$x"
done
