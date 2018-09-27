//
//  UICollectionReusableView+Reuse.swift
//  SwiftyRatingsView
//
//  Created by Dominik on 26/09/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import UIKit

extension UICollectionReusableView { // also incluces UICollectionViewCell
    
    static var reuseId: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseId, bundle: Bundle(for: self))
    }
}
