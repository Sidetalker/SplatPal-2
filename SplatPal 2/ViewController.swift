//
//  ViewController.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadRotations))
        statusLabel.addGestureRecognizer(tapRecognizer)
        
        loadRotations()
    }
    
    func loadRotations() {
        log.info("Logging rotations")
        
        activityIndicator.startAnimating()
        statusLabel.text = "Loading Rotations"
        
        firstly {
            Splatter.fetchRotations(source: .splatInk)
        }.then { maps -> Void in
            var displayText = "Last updated \(SplatFormatter.shared.currentTimestamp)\n\n"
            maps.forEach { displayText += "\($0.debugDescription)\n\n" }
            
            self.dataLabel.text = displayText
            self.statusLabel.text = "Loaded (tap to refresh)"
        }.catch { error in
            log.error("Error loading maps: \(error.localizedDescription)")
            
            self.dataLabel.text = "Oh no errors"
            self.statusLabel.text = "Error (tap to refresh)"
        }.always {
            self.activityIndicator.stopAnimating()
        }
    }

}

