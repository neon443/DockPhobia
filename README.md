<div align="center">
    <br/>
    <p>
        <img src="https://github.com/neon443/DockPhobia/blob/main/DockPhobia/Resources/Assets.xcassets/AppIcon.appiconset/DockPhobiaAppIcon.png?raw=true" title="dockphobia" alt="dockphobia icon" width="150" />
    </p>
      <h3>DockPhobia</h3>
        <p>
        <a href="https://github.com/neon443/DockPhobia/releases/latest/download/DockPhobia.dmg">
            download
            <img alt="GitHub Release" src="https://img.shields.io/github/v/release/neon443/DockPhobia">
        </a>
    </p>
    <p>
        make your Dock scared of the mouse
        <br/>
        <a href="https://neon443.github.io">
            made by neon443
        </a>
    </p>
    <br/>
</div>

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/neon443/DockPhobia/total)

<div align="center">
  <a href="https://shipwrecked.hackclub.com/?t=ghrm" target="_blank">
    <img src="https://hc-cdn.hel1.your-objectstorage.com/s/v3/739361f1d440b17fc9e2f74e49fc185d86cbec14_badge.png" 
         alt="This project is part of Shipwrecked, the world's first hackathon on an island!" 
         style="width: 25%;">
  </a>
</div>

Have you ever wanted to use your Dock?
well now you cant

## This masterclass of an app does the following:
- tracks your mouse
- calculates the size of your screen & Dock
- when your cursor is on the Dock (+ extra 5% of screen), the Dock moves to a different side of the screen
- it also figures out the furthest it can be, for example if your cursor is at the top left quarter of the screen and near the Dock on the left, the dock moves to the bottom as that is the furthest, etc

## Quick start Guide (Mac App)
- Go to [releases](https://github.com/neon443/DockPhobia/releases)
- Download the latest version
- That's it!

## Contributing
PRs welcome, as long as you use tabs instead of spaces lol

## Quick start Guide (Python version)
Dont use this, still here purely for archival purposes, use the native Mac app instead.
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
