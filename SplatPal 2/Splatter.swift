//
//  Splatter.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit
import PromiseKit
import PMKAlamofire
import SwiftyJSON
import SwiftyBeaver

/**
 Potential datasources for Splatoon information
    - splatInk: splatoon.ink
    - splatApi: splatpal.herokuapp.com
 */
enum SplatterSource {
    case splatInk, splatPal
    
    var url: String {
        switch self {
        case .splatInk:
            return "https://splatoon.ink/schedule.json"
        case .splatPal:
            return "https://splatpal.herokuapp.com"
        }
    }
}

/// Provides static methods for updating SplatData
class Splatter {
    
    /**
     Fetches the latest map rotation data
     
     - parameter source: Data source from which to retrieve
     - returns: Promise with array of current/upcoming map rotations
    */
    class func fetchRotations(source: SplatterSource = .splatInk) -> Promise<[Rotation]> {
        log.debug("Fetching rotations from \(String(describing: source))")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            request(source.url).responseData()
        }.then(on: DispatchQueue.main) { data -> Promise<[Rotation]> in
            return Splatter.parseRotations(from: source, json: JSON(data: data))
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private class func parseRotations(from: SplatterSource, json: JSON) -> Promise<[Rotation]> {
        return parseSplatInkRotations(json: json)
    }
    
    private class func parseSplatInkRotations(json: JSON) -> Promise<[Rotation]> {
        var rotations: [Rotation] = []
        
        for entry in json["schedule"].arrayValue {
            let startTime = Date(timeIntervalSince1970: entry["startTime"].doubleValue / 1000)
            let endTime = Date(timeIntervalSince1970: entry["endTime"].doubleValue / 1000)
            let mode = Mode(name: entry["ranked"]["rulesEN"].stringValue)
            
            let rankedStages = [
                Stage(name: entry["ranked"]["maps"][0]["nameEN"].stringValue),
                Stage(name: entry["ranked"]["maps"][1]["nameEN"].stringValue)
            ]
            
            let regularStages = [
                Stage(name: entry["regular"]["maps"][0]["nameEN"].stringValue),
                Stage(name: entry["regular"]["maps"][1]["nameEN"].stringValue),
            ]
            
            let rotation = Rotation(startTime: startTime,
                                    endTime: endTime,
                                    rankedStages: rankedStages,
                                    regularStages: regularStages,
                                    rankedMode: mode)
            
            rotations.append(rotation)
        }
        
        log.debug("Finished parsing \(rotations.count) rotation(s)")
        
        return Promise<[Rotation]>(value: rotations)
    }
}
