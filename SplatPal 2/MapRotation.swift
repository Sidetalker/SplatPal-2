//
//  MapRotation.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

/// A Splatoon 1 Map Rotation consists of a single mode and two maps
public struct MapRotation {
    public internal(set) var startTime: Date
    public internal(set) var endTime: Date
    public internal(set) var maps: [Map]
    public internal(set) var mode: Mode
}

extension MapRotation {
    class Coding: NSObject, NSCoding {
        let rotation: MapRotation?
        
        init(rotation: MapRotation) {
            self.rotation = rotation
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let startTime = aDecoder.decodeObject(forKey: "startTime") as? Date,
                let endTime = aDecoder.decodeObject(forKey: "endTime") as? Date,
                let codedMaps = aDecoder.decodeObject(forKey: "maps") as? [Map.Coding],
                let codedMode = aDecoder.decodeObject(forKey: "mode") as? Mode.Coding,
                let maps = codedMaps.decoded as? [Map],
                let mode = codedMode.decoded as? Mode
            else {
                return nil
            }
            
            rotation = MapRotation(startTime: startTime, endTime: endTime, maps: maps, mode: mode)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let rotation = rotation else {
                return
            }
            
            aCoder.encode(rotation.startTime, forKey: "startTime")
            aCoder.encode(rotation.endTime, forKey: "endTime")
            aCoder.encode(rotation.maps.encoded, forKey: "maps")
            aCoder.encode(rotation.mode.encoded, forKey: "mode")
        }
    }
}

extension MapRotation: Encodable {
    var encoded: Decodable? {
        return MapRotation.Coding(rotation: self)
    }
}

extension MapRotation.Coding: Decodable {
    var decoded: Encodable? {
        return self.rotation
    }
}
