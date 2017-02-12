//
//  Map.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

/// Splatoon map (or stage)
public struct Map {
    public internal(set) var id: String
    
    /// Localized name of the map
    public internal(set) var name: String
    
    /// 580x326 px image of the map
    public internal(set) var image: UIImage?
}

extension Map {
    class Coding: NSObject, NSCoding {
        let map: Map?
        
        init(map: Map) {
            self.map = map
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let id = aDecoder.decodeObject(forKey: "id") as? String,
                let name = aDecoder.decodeObject(forKey: "name") as? String
            else {
                return nil
            }
            
            map = Map(id: id, name: name, image: nil)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let map = map else {
                return
            }
            
            aCoder.encode(map.id, forKey: "id")
            aCoder.encode(map.name, forKey: "name")
        }
    }
}

extension Map: Encodable {
    var encoded: Decodable? {
        return Map.Coding(map: self)
    }
}

extension Map.Coding: Decodable {
    var decoded: Encodable? {
        return self.map
    }
}
