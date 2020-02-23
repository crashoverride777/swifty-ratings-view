//    The MIT License (MIT)
//
//    Copyright (c) 2019-2020 Dominik Ringler
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import UIKit

public final class SwiftyRatingsControl: UIControl {
    
    // MARK: - Types
    
    public struct Model {
        let image: UIImage
        let numberOfItems: Int
        let startRating: Int?
        let selectedColor: UIColor
        let deselectedColor: UIColor
        let count: Int?
        
        public init(image: UIImage,
                    numberOfItems: Int,
                    startRating: Int?,
                    selectedColor: UIColor,
                    deselectedColor: UIColor,
                    count: Int?) {
            self.image = image
            self.numberOfItems = numberOfItems
            self.startRating = startRating
            self.selectedColor = selectedColor
            self.deselectedColor = deselectedColor
            self.count = count
        }
    }
    
    // MARK: - Properties
    
    private let handler: (Int) -> Void
    private var currentRating: Int?
    private var lastTag: Int?
    private lazy var buttons = ratingsStackView.arrangedSubviews.map { $0 as! SwiftyRatingsControlButton }
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var ratingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingsStackView, countLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0)
        return stackView
    }()
    
    // MARK: - Init
    
    public init(handler: @escaping (Int) -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        // Add corner radius
        clipsToBounds = true
        layer.cornerRadius = 4
        
        // Add subviews
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: Model) {
        self.currentRating = model.startRating
        
        // Update count label
        countLabel.isHidden = model.count == nil
        if let count = model.count {
            countLabel.text = "(\(count))"
        } else {
            countLabel.text = nil
        }
        
        // Setup buttons
        ratingsStackView.arrangedSubviews.forEach {
            ratingsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        (1...5).forEach { index in
            let button = SwiftyRatingsControlButton(
                tag: index,
                image: model.image,
                selectedColor: model.selectedColor,
                deselectedColor: model.deselectedColor,
                isRated: model.startRating == nil ? false : index <= model.startRating!,
                action: { [weak self] button in
                    self?.ratingsButtonPressed(button)
                }
            )
            ratingsStackView.addArrangedSubview(button)
        }
    }
    
    /// Add blur to SwiftyRatingsView
    ///
    /// - parameter style: The UIBlurEffect style.
    /// - parameter color: The color of the blur effect.
    public func addBlurView(_ style: UIBlurEffect.Style, color: UIColor = .orange) {
        subviews.forEach {
            guard $0 is UIVisualEffectView else {
                return
            }
            
            $0.removeFromSuperview()
        }
        addBlur(style)
    }
}

// MARK: - Private Methods

private extension SwiftyRatingsControl {
    
    func addBlur(_ style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurEffectView, at: 0)
        
        NSLayoutConstraint.activate([
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func ratingsButtonPressed(_ sender: SwiftyRatingsControlButton) {
        defer {
            // Update rating
            var rating = sender.tag
            if !sender.isRated {
                rating -= 1
            }
            
            // Return handler
            print(rating)
            handler(rating)
        }
        
        // Check if we are on same item (2nd press)
        guard lastTag != sender.tag else {
            sender.isRated.toggle()
            return
        }
        
        // Update cell appearances
        buttons.forEach {
            if $0.tag > sender.tag { // Deselect all cells higher than new rating
                $0.isRated = false
            } else if $0.tag == sender.tag, currentRating == sender.tag { // Update current cell
                $0.isRated.toggle()
            } else {
                $0.isRated = $0.tag <= sender.tag // Udpdate other cells
            }
        }
        
        // Update last index path after loop
        // so the guard statement at top ignores 1st presses
        // to make sure other items are selected/deselected if needed
        lastTag = sender.tag
    }
}
