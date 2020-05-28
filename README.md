dotfiles
========
My personal configuration files that I use on Linux and Max OS X.
If you want to use the vim configuration with powerline/tmux, you'll need to install the powerline [fonts](https://github.com/boogy/dotfiles/tree/master/deploy/conf/fonts).

Installation
============================
```bash
$ git clone https://github.com/boogy/dotfiles.git
$ cd dotfiles
$ ./install.sh
```
Or directly with:

#### ATTENTION:
If parameter **yes** is supplied the script will **delete** existing files and directorys in your home directory that are also present in the dotfile configuration. They are declared in the **MANAGED_FILES** array. So if you don't want to delete them specify **no** parameter to the script.

```bash
$ wget -qO - https://raw.githubusercontent.com/boogy/dotfiles/master/install.sh | bash -s no
```

Usage
============================
Add `.bash_aliases` for linux in general:

```bash
echo "source ~/.bash_aliases" >> .bashrc
```
Or for Mac OS X
```bash
echo "source ~/.bash_aliases" >> .profile
#OR
echo "source ~/.bash_aliases" >> .bash_profile
```

To bootstrap a new Mac OS X box just run the deploy osx:

```bash
bash ~/dotfiles/deploy/osx
```

And for linux also:

```bash
bash ~/dotfiles/deploy/linux
```
