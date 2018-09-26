# Swifty Ratings View

# SwiftyRate

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-ED523F.svg?style=flat)](https://swift.org/download/)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyRate.svg?style=flat)]()
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftyRatingsView.svg)](https://img.shields.io/cocoapods/v/SwiftyRatingsView.svg)

A simpler ratings view. No fuss.

## Requirements

- iOS 9.3+
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

There is 2 ways you can add the ratings view to your app.

Way 1, Stack views (preferred)

Add a stack view to your desired view, give it a width and height constraints of your desired size and other constraints you need. Than create an outlet from the stack view in your storyboard to your UIView class.
```swift
@IBOutlet weak var ratingsStackView: UIStackView!
```
Create a lazy property to instantiate the ratingsView itself. Call the configure method to setup the ratings view and add the callback handler to listen for ratings changes.
```swift
 private lazy var ratingsView: RatingsView = {
        $0.configure(with: UIImage(named: "star")!, totalRatingsCount: 5, currentRating: 2)
        $0.handler = { [weak self] rating in
            print(rating)
            // Do your thing
        }
        return $0
    }(RatingsView.instantiate())
```swift

You can also further call these methods to configure the ratings view
```swift
$0.setColors(selected: .orange, deselected: .gray)
$0.addBlur(.light, color: .orange)   
```

Finally add the ratingsView to your stackView via its didSet method.
```swift
@IBOutlet weak var ratingsStackView: UIStackView! {
    didSet {
       ratingsStackView.addArrangedSubview(ratingsView)
    }
}

Full sample code (also check sample project)

```swift
class ViewController: UIViewController {

    private lazy var ratingsView: RatingsView = {
        $0.configure(with: UIImage(named: "star")!, totalRatingsCount: 5, currentRating: 2)
        //$0.setColors(selected: .orange, deselected: .gray)
        $0.handler = { [weak self] rating in
            print(rating)
        }
        return $0
    }(RatingsView.instantiate())
    
    @IBOutlet weak var ratingsStackView: UIStackView! {
        didSet {
            ratingsStackView.addArrangedSubview(ratingsView)
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ...
    }
}

```
