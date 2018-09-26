//
//  SwiftyRatingsViewCell.swift
//  Greeny
//
//  Created by Dominik on 20/06/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import UIKit

protocol SwiftyRatingsViewCellConfigurable {
    func configure(with image: UIImage, selectedColor: UIColor, deselectedColor: UIColor, isRated: Bool)
}

final class SwiftyRatingsViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: - Properties
    
    var isRated = false {
        didSet {
            iconImageView.tintColor = isRated ? selectedColor : deselectedColor
        }
    }
    
    private var selectedColor: UIColor = .orange
    private var deselectedColor: UIColor = .gray
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .clear
    }
}

// MARK: - SwiftyRatingsViewCellConfigurable

extension SwiftyRatingsViewCell: SwiftyRatingsViewCellConfigurable {
   
    func configure(with image: UIImage, selectedColor: UIColor, deselectedColor: UIColor, isRated: Bool) {
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
        self.isRated = isRated
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
}
