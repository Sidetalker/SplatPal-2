//
//  Rotation.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

/// A Splatoon 1 Rotation consists of a ranked mode + 2 maps and a regular (SplatZones) mode + 2 maps
public struct Rotation: CustomStringConvertible {
    public internal(set) var startTime: Date
    public internal(set) var endTime: Date
    public internal(set) var rankedStages: [Stage]
    public internal(set) var regularStages: [Stage]
    public internal(set) var rankedMode: Mode
    
    public var description: String {
        let start = SplatFormatter.shared.microDayTime(from: startTime)
        let end = SplatFormatter.shared.microDayTime(from: endTime)
        
        return "[Map Rotation | \(start) to \(end)]"
    }
    
    public var debugDescription: String {
        return "\(description)\n"
            + "Turf Wars: \(regularStages[0]) + \(regularStages[1])\n"
            + "\(rankedMode): \(rankedStages[0]) + \(rankedStages[1])"
    }
}

extension Rotation {
    class Coding: NSObject, NSCoding {
        let rotation: Rotation?
        
        init(rotation: Rotation) {
            self.rotation = rotation
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let startTime = aDecoder.decodeObject(forKey: "startTime") as? Date,
                let endTime = aDecoder.decodeObject(forKey: "endTime") as? Date,
                let codedRankedStages = aDecoder.decodeObject(forKey: "rankedStages") as? [Stage.Coding],
                let codedRegularStages = aDecoder.decodeObject(forKey: "regularStages") as? [Stage.Coding],
                let codedMode = aDecoder.decodeObject(forKey: "rankedMode") as? Mode.Coding,
                let rankedStages = codedRankedStages.decoded as? [Stage],
                let regularStages = codedRegularStages.decoded as? [Stage],
                let rankedMode = codedMode.decoded as? Mode
            else {
                return nil
            }
            
            rotation = Rotation(startTime: startTime, endTime: endTime, rankedStages: rankedStages, regularStages: regularStages, rankedMode: rankedMode)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let rotation = rotation else {
                return
            }
            
            aCoder.encode(rotation.startTime, forKey: "startTime")
            aCoder.encode(rotation.endTime, forKey: "endTime")
            aCoder.encode(rotation.rankedStages.encoded, forKey: "rankedStages")
            aCoder.encode(rotation.regularStages.encoded, forKey: "regularStages")
            aCoder.encode(rotation.rankedMode.encoded, forKey: "rankedMode")
        }
    }
}

extension Rotation: Encodable {
    var encoded: Decodable? {
        return Rotation.Coding(rotation: self)
    }
}

extension Rotation.Coding: Decodable {
    var decoded: Encodable? {
        return self.rotation
    }
}
