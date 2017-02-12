//
//  Mod.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

public enum ModeType: Int {
    case casual, ranked
}

/// Splatoon game mode
public struct Mode {
    public internal(set) var id: String
    
    /// Localized name of the mode
    public internal(set) var name: String
    
    /// 80x80 px icon for mode
    public internal(set) var icon: UIImage?
    
    /// The type of the mode (casual or ranked)
    public internal(set) var type: ModeType
}

extension Mode {
    class Coding: NSObject, NSCoding {
        let mode: Mode?
        
        init(mode: Mode) {
            self.mode = mode
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let id = aDecoder.decodeObject(forKey: "id") as? String,
                let name = aDecoder.decodeObject(forKey: "name") as? String,
                let rawType = aDecoder.decodeObject(forKey: "type") as? Int,
                let type = ModeType(rawValue: rawType)
            else {
                return nil
            }
            
            mode = Mode(id: id, name: name, icon: nil, type: type)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let mode = mode else {
                return
            }
            
            aCoder.encode(mode.id, forKey: "id")
            aCoder.encode(mode.name, forKey: "name")
            aCoder.encode(mode.type.rawValue, forKey: "type")
        }
    }
}

extension Mode: Encodable {
    var encoded: Decodable? {
        return Mode.Coding(mode: self)
    }
}

extension Mode.Coding: Decodable {
    var decoded: Encodable? {
        return self.mode
    }
}
