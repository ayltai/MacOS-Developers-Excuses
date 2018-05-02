# Developers Excuses
A macOS screen saver that shows a random [developer excuse](http://www.devexcuses.com) over a [beautiful photo background](https://unsplash.com). Made with ❤

![Screenshot 1](Screenshots/screenshot-1.jpg)

![Screenshot 2](Screenshots/screenshot-2.jpg)

![Screenshot 3](Screenshots/screenshot-3.jpg)

## Features
* Periodically refresh the background image from [Unsplash](https://unsplash.com)
* Periodically refresh the quote from [Developer Excuses](http://www.devexcuses.com)
* Animate the background image with [Ken Burns effect](https://en.wikipedia.org/wiki/Ken_Burns_effect)
* Automatically start recording video using the built-in FaceTime HD camera for security reasons

## Parameters
All parameters can be adjusted in [`DEConfigs.swift`](https://github.com/ayltai/Developers-Excuses/blob/master/DevExcuses/Sources/DEConfigs.swift).

### Background image
| Parameter                | Purpose          | Default                                                                                                                                                                                                                                                                                                                         |
|:-------------------------|:-----------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DEConfigs.Image.apiKey` | Unsplash API key | (empty)                                                                                                                                                                                                                                                                                                                         |
| `DEConfigs.Image.alpha`  | Image alpha      | 0.85                                                                                                                                                                                                                                                                                                                            |
| `DEConfigs.Image.topics` | Image seach tags | nature<br>landscape<br>water<br>sea<br>forest<br>outdoor<br>indoor<br>interior<br>wallpaper<br>urban<br>city<br>street<br>tropical<br>rock<br>abandoned<br>adventure<br>architecture<br>retro<br>vintage<br>coffee<br>espresso<br>cafe<br>mac<br>imac<br>macbook<br>iphone<br>ipad<br>android<br>computer<br>programming<br>technology<br>animal |

### Font - Main text
| Parameter                       | Purpose                                  | Default |
|:--------------------------------|:-----------------------------------------|--------:|
| `DEConfigs.Excuse.Font.name`    | Center text font for developers' excuses | Menlo   |
| `DEConfigs.Excuse.Font.size`    | Center text size for developers' excuses | 45      |
| `DEConfigs.Excuse.Font.preview` | Center text size in preview mode         | 10      |

### Font - Credit text
| Parameter                       | Purpose                                                      | Default |
|:--------------------------------|:-------------------------------------------------------------|--------:|
| `DEConfigs.Credit.Font.name`    | Bottom left and right text font for background image credits | Menlo   |
| `DEConfigs.Credit.Font.size`    | Bottom left and right text size for background image credits | 12      |
| `DEConfigs.Credit.Font.preview` | Bottom left and right text in preview mode                   | 6       |

### Shadow - Main text
| Parameter                        | Purpose                                                | Default |
|:---------------------------------|:-------------------------------------------------------|--------:|
| `DEConfigs.Excuse.Shadow.offset` | Center text drop shadow horizontal and vertical offset | 0       |
| `DEConfigs.Excuse.Shadow.radius` | Center text drop shadow radius                         | 12      |

### Shadow - Credit text
| Parameter                        | Purpose                                                               | Default |
|:---------------------------------|:----------------------------------------------------------------------|--------:|
| `DEConfigs.Excuse.Shadow.offset` | Bottom left and right text drop shadow horizontal and vertical offset | 0       |
| `DEConfigs.Excuse.Shadow.radius` | Bottom left and right text drop shadow radius                         | 6       |

### Ken Burns effect
| Parameter                         | Purpose                                              |                                                            |
|:----------------------------------|:-----------------------------------------------------|-----------------------------------------------------------:|
| `DEConfigs.Effect.maxScale`       | Maximum zoom scale                                   | 1.75                                                       |
| `DEConfigs.Effect.minScale`       | Minimum zoom scale                                   | 1                                                          |
| `DEConfigs.Effect.maxTranslation` | Maximum horizontal and vertical translation distance | 0                                                          |
| `DEConfigs.Effect.minTranslation` | Minimum horizontal and vertical translation distance | `-(DEConfigs.Effect.maxScale - DEConfigs.Effect.minScale)` |

### General
| Parameter                       | Purpose                                   | Default        |
|:--------------------------------|:------------------------------------------|---------------:|
| `DEConfigs.refreshTimeInterval` | Background image refresh time interval    | 15 seconds     |

## Compatibility
Developers Excuses screen saver requires OS X Yosemite or later.
