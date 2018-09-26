//
//  UICollectionView+Appearance.swift
//  SwiftyRatingsView
//
//  Created by Dominik on 26/09/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    var widthWithoutInsets: CGFloat {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let flowLayoutCombinedInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let safeAreaCombinedInsets = safeAreaInsets.left + safeAreaInsets.right
        return frame.width - flowLayoutCombinedInsets - safeAreaCombinedInsets//- (contentInset.top + contentInset.bottom)
    }
    
    var heightWithoutInsets: CGFloat {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let flowLayoutCombinedInsets = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
        let safeAreaCombinedInsets = safeAreaInsets.top + safeAreaInsets.bottom
        return frame.height - flowLayoutCombinedInsets - safeAreaCombinedInsets//- (contentInset.top + contentInset.bottom)
    }
}
