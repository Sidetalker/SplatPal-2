//
//  ViewController.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        Splatter.fetchRotations(source: .splatInk).then { maps -> Void in
            log.debug("Loaded maps")
            maps.forEach { log.verbose("\($0.debugDescription)") }
        }.catch { error in
            log.error("Error loading maps: \(error.localizedDescription)")
        }
    }

}

