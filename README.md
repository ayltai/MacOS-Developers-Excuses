# Developers Excuses

[![Release](https://img.shields.io/github/release/ayltai/MacOS-Developers-Excuses.svg?label=release&maxAge=1800)](Releases/1.1/screensaver.zip) [![macOS](https://img.shields.io/badge/macOS-10.10-blue.svg?style=flat&label=macOS&maxAge=300)](https://en.wikipedia.org/wiki/OS_X_Yosemite) [![License](https://img.shields.io/badge/License-apache%202.0-blue.svg?label=license&maxAge=1800)](https://github.com/ayltai/MacOS-Developers-Excuses/blob/master/LICENSE)

A macOS screen saver that shows a random [developer excuse](http://www.devexcuses.com) over a [beautiful photo background](https://unsplash.com). Made with ❤

![Screenshot 1](Screenshots/screenshot-1.jpg)

![Screenshot 2](Screenshots/screenshot-2.jpg)

![Screenshot 3](Screenshots/screenshot-3.jpg)

## Features
* Periodically refresh the background image from [Unsplash](https://unsplash.com)
* Periodically refresh the quote from [Developer Excuses](http://www.devexcuses.com)
* Animate the background image with [Ken Burns effect](https://en.wikipedia.org/wiki/Ken_Burns_effect)
* Automatically start recording video using the built-in FaceTime HD camera for security reasons

## Configurations
![Configurations](Screenshots/configurations.png)

## Downloads
### [Screen Saver](Releases/1.1/screensaver.zip)
Double-click to install.

### [Security Camera](Releases/1.1/SecurityCamera.zip)
Place it to somewhere handy, such as `~/Downloads` or `/usr/bin`, and then update its path in the screen saver configurations .

## Compatibility
Developers Excuses screen saver requires OS X Yosemite or later.

## How to build
0. Install [CocoaPods](https://cocoapods.org)
1. Run `pod install`
2. Open `DevExcuses.xcworkspace` in Xcode
3. Build both SecurityCamera and DevExcuses projects
