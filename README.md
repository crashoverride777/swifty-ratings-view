# Swifty Ratings Control

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-ED523F.svg?style=flat)](https://swift.org/download/)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyRate.svg?style=flat)]()
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftyRatingsView.svg)](https://img.shields.io/cocoapods/v/SwiftyRatingsView.svg)

A simpler ratings view. No fuss. Features swipe gesture.

## Requirements

- iOS 11.4+
- Swift 4.0+

## Installation

[CocoaPods](https://developers.google.com/admob/ios/quick-start#streamlined_using_cocoapods) is a dependency manager for Cocoa projects. Simply install the pod by adding the following line to your pod file


```swift
pod 'SwiftyRatingsView'
```

Altenatively you can drag the swift file(s) and XIBs manually into your project.

## Usage

- Add the import statment when you installed via cocoa pods. 

```swift
import SwiftyRatingsView 
```

- Add to view

Create a lazy property to instantiate the ratings control and add it to your views or stack views.
```swift
private lazy var ratingsControl: RatingsControl = {
    let control = RatingsControl()
    control.translatesAutoresizingMaskIntoConstraints = false
    control.addBlurView(.regular)
    control.handler = { [weak self] rating in
        // Rating changed, do something
    }
    control.widthAnchor.constraint(equalToConstant: 120).isActive = true
    control.heightAnchor.constraint(equalToConstant: 28).isActive = true
    return control
}()
```

Configure the ratings control either in the lazy property or dynamically when needed
```swift
let ratingsControlModel = RatingsControl.Model(
    image: UIImage(named: "someImage",
    numberOfItems: 5,
    startRating: 0,
    selectedColor: .orange,
    deselectedColor: .lightGray,
    count: nil
)
ratingsControl.configure(with: ratingsControlModel)
```
