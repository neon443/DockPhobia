# DockPhobia

Have you ever wanted to use your Dock?
well now you cant

## This masterclass of an app does the following:
- tracks your mouse
- calculates the size of your screen & Dock
- when your cursor is on the Dock (+ extra 5% of screen), the Dock moves to a different side of the screen
- it also figures out the furthest it can be, for example if your cursor is at the top left quarter of the screen and near the Dock on the left, the dock moves to the bottom as that is the furthest, etc
- -

## Quick start Guide (Swift Mac App)
(Currently not functional)
```
git clone https://github.com/neon443/DockPhobia
cd DockPhobia
open DockPhobia.xcodeproj
```

## Quick start Guide (Python version)
```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install python3
```
```
git clone https://github.com/neon443/DockPhobia
cd DockPhobia/DockPhobiaPy
python3 -m venv venv
. venv/bin/activate
pip3 install -r requirements.txt
python3 main.py
```
