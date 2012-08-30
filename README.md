dotfiles
-------

repository for distributing my dotfiles consistently 

The following markups are supported.  The dependencies listed are required if
you wish to run the library.

### Installing

Clone it from github:

    git clone http://github.com/muelma/dotfiles.git

I suggest you to read and understand the bootstrap.sh - script. It looks for all files contained in the dotfiles directory and it's subdirectories, then it walks through your $HOME-directory putting all dotfiles with the same name into a tar.gz for backup. Then all dotfiles in your $HOME-directory and its subdirectories get symlinked into the dotfiles directory.
Setting up your home folder:

    cd dotfiles
    ./bootstrap.sh

If you don't want this, just copy the files from dotfiles in your $HOME directory. But you will have to repeat that after each update.

### Other scripts

setup-gnawesome.sh:

Creates a Login Session for unity-greeter within Ubuntu that starts the Awesome Window Manager in a gnome-session.

    cd dotfiles
    sudo ./setup-gnawesome.sh

gsettings.sh:

Disables the Gnome desktop background and icons.
