//
//  SwiftyRatingsView.swift
//  Greeny
//
//  Created by Dominik on 20/06/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import UIKit

public protocol SwiftyRatingsViewConfigurable {
    func configure(with configuration: SwiftyRatingsView.Configuration)
    func addBlur(_ style: UIBlurEffect.Style, color: UIColor)
}

public final class SwiftyRatingsView: UIView {
    
    // MARK: - Types
    
    public struct Configuration {
        let image: UIImage
        let numberOfItems: Int
        let startRating: Int
        let selectedColor: UIColor
        let deselectedColor: UIColor
        
        public init(image: UIImage, numberOfItems: Int, startRating: Int, selectedColor: UIColor, deselectedColor: UIColor) {
            self.image = image
            self.numberOfItems = numberOfItems
            self.startRating = startRating
            self.selectedColor = selectedColor
            self.deselectedColor = deselectedColor
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SwiftyRatingsViewCell.nib, forCellWithReuseIdentifier: SwiftyRatingsViewCell.reuseId)
            collectionView.backgroundView = nil
            collectionView.backgroundColor = .red
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.cancelsTouchesInView = false
            collectionView.addGestureRecognizer(panGesture)
        }
    }
    
    // MARK: - Properties
    
    /// Handler that gets called when rating changes.
    public var handler: ((Int) -> Void)?
    
    /// Private
    private var configuration: Configuration!
    private var currentRating = 0
    private var lastIndexPath: IndexPath?
    
    // MARK: - Init
    
    public static func instantiate() -> SwiftyRatingsView {
        let view = Bundle.framework.loadNibNamed("\(SwiftyRatingsView.self)", owner: nil, options: nil)!.first as! SwiftyRatingsView
        return view
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .clear
    }
}

// MARK: - SwiftyRatingsViewConfigurable

extension SwiftyRatingsView: SwiftyRatingsViewConfigurable {
    
    /// Configure SwiftyRatingsView
    ///
    /// - parameter configuration: A struct to setup SwiftyRatingsView.
    public func configure(with configuration: Configuration) {
        self.configuration = configuration
        self.currentRating = configuration.startRating
        collectionView.reloadData()
    }
    
    /// Add blur to SwiftyRatingsView
    ///
    /// - parameter style: The UIBlurEffect style.
    /// - parameter color: The color of the blur effect.
    public func addBlur(_ style: UIBlurEffect.Style, color: UIColor = .orange) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = color == .clear ? .clear : color.withAlphaComponent(0.7)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension SwiftyRatingsView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftyRatingsViewCell.reuseId, for: indexPath) as! SwiftyRatingsViewCell
        cell.configure(
            with: configuration.image,
            selectedColor: configuration.selectedColor,
            deselectedColor: configuration.deselectedColor,
            isRated: indexPath.row <= max(0, (configuration.startRating - 1)) // -1 as indexPath starts at 0
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SwiftyRatingsView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! SwiftyRatingsViewCell
        
        defer {
            // Update rating
            currentRating = rating(at: indexPath)
            if !currentCell.isRated {
                currentRating -= 1
            }
            
            // Return handler
            handler?(currentRating)
        }
        
        // Check if we are on same item (2nd press)
        guard lastIndexPath != indexPath else {
            currentCell.isRated.toggle()
            return
        }
        
        // Update cell appearances
        collectionView.visibleCells.forEach {
            let cell = $0 as! SwiftyRatingsViewCell
            guard let cellIndexPath = collectionView.indexPath(for: $0) else { return }
            
            // Deselect all cells higher than current index path
            if cellIndexPath.row > indexPath.row {
                cell.isRated = false
            }
            // Update current cell
            else if cellIndexPath.row == indexPath.row, currentRating == rating(at: indexPath) {
                cell.isRated.toggle()
            }
            // Udpdate other cells
            else {
                cell.isRated = cellIndexPath.row <= indexPath.row
            }
        }
        
        // Update last index path after loop
        // so the guard statement at top ignores 1st presses
        // to make sure other items are selected/deselected if needed
        lastIndexPath = indexPath
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SwiftyRatingsView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow = CGFloat(configuration.numberOfItems)
        let horizontalSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        let cellWidth = (collectionView.widthWithoutInsets - max(0, numberOfCellsPerRow - 1) * horizontalSpacing) / numberOfCellsPerRow
        return CGSize(width: cellWidth, height: collectionView.heightWithoutInsets)
    }
}

// MARK: - Callbacks

private extension SwiftyRatingsView {

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        
        case .began:
            collectionView.isUserInteractionEnabled = false
            collectionView.isScrollEnabled = false
       
        case .changed:
            let location = recognizer.location(in: collectionView)
            
            // Get index path at location
            guard let indexPath  = collectionView.indexPathForItem(at: location) else { return }
            lastIndexPath = indexPath
            
            // Get cell at index path
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            
            // If touch smaller than collection view min X + half of cell width, toggle 1st cell end return
            guard location.x >= (collectionView.frame.minX + (cell.bounds.width / 2.5)) else {
                let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! SwiftyRatingsViewCell
                cell.isRated = false
                lastIndexPath = nil
                print("SwiftyRatingsview user swiped offscreen")
                return
            }
            
            // Update cells
            print("SwiftyRatingsview updating cells")
            for cell in collectionView.visibleCells {
                guard let cellIndexPath = collectionView.indexPath(for: cell) else { continue }
                (cell as! SwiftyRatingsViewCell).isRated = cellIndexPath <= indexPath
            }
           
        case .ended:
            collectionView.isUserInteractionEnabled = true
            collectionView.isScrollEnabled = true
            handler?(lastIndexPath == nil ? 0 : rating(at: lastIndexPath!))
            
        default:
            break

        }
    }
}

// MARK: - Helpers

private extension SwiftyRatingsView {
    
    func rating(at indexPath: IndexPath) -> Int {
        return indexPath.row + 1
    }
}
