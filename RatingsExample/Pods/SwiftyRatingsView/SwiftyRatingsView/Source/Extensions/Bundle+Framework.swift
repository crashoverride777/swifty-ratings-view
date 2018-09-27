//
//  Bundle+Framework.swift
//  SwiftyRatingsView
//
//  Created by Dominik on 26/09/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import Foundation

extension Bundle {
    //static let framework = Bundle(forClass: SwiftyRatingsView.self)//Bundle(identifier: "com.dominik.swiftyratingsview")!
    
    static var framework: Bundle {
        let bundle = Bundle(for: SwiftyRatingsView.self)
        let podBundle = Bundle(path: bundle.path(forResource: "SwiftyRatingsView", ofType: "bundle")!)
        print("podBundle :\(podBundle!)")
        return podBundle!
        //let bundle = Bundle(for: SwiftyRatingsView.self)
        //let bundleURL = bundle.url(forResource: "SwiftyRatingsView", withExtension: "bundle")//resourceURL?.appendingPathComponent("SwiftyRatingsView.bundle")
        //url(forResource: "SwiftyRatingsView", withExtension: "bundle")
        //let resourceBundle = Bundle(url: bundleURL!)
        //return resourceBundle ?? Bundle(for: SwiftyRatingsView.self)
    }
}
