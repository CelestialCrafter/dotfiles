shopt -s extglob
ln -s !(LICENSE|README.md|$(basename $0)) ~/.config/
