//
//  ViewController.swift
//  RatingsExample
//
//  Created by Dominik on 26/09/2018.
//  Copyright © 2018 Dominik. All rights reserved.
//

import UIKit
import SwiftyRatingsView

class ViewController: UIViewController {

    // Way 1, stack view
    private lazy var ratingsView: SwiftyRatingsView = {
        let configuration = SwiftyRatingsView.Configuration(
            image: UIImage(named: "star")!,
            numberOfItems: 5,
            startRating: 2,
            selectedColor: .orange,
            deselectedColor: .gray
        )
        $0.configure(with: configuration)
        $0.handler = { [weak self] rating in
            print(rating)
        }
        $0.backgroundColor = .purple
        return $0
    }(SwiftyRatingsView.instantiate())
    
    @IBOutlet weak var ratingsStackView: UIStackView! {
        didSet {
            ratingsStackView.addArrangedSubview(ratingsView)
        }
    }
    
    // Way 2 code
    private lazy var ratingsView2: SwiftyRatingsView = {
        let configuration = SwiftyRatingsView.Configuration(
            image: UIImage(named: "star")!,
            numberOfItems: 5,
            startRating: 2,
            selectedColor: .orange,
            deselectedColor: .gray
        )
        $0.configure(with: configuration)
        $0.handler = { [weak self] rating in
            print(rating)
        }
        $0.backgroundColor = .purple
        return $0
    }(SwiftyRatingsView.instantiate())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        // add ratings view 2 (way 2)
        view.addSubview(ratingsView2)
        ratingsView2.translatesAutoresizingMaskIntoConstraints = false
        ratingsView2.widthAnchor.constraint(equalToConstant: 160).isActive = true
        ratingsView2.heightAnchor.constraint(equalToConstant: 42).isActive = true
        ratingsView2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        ratingsView2.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}

