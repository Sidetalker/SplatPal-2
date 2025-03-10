//
//  Mod.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

/// Splatoon game mode
public struct Mode: CustomStringConvertible {
    public internal(set) var id: String
    
    /// Localized name of the mode
    public internal(set) var name: String
    
    /// 80x80 px icon for mode
    public internal(set) var icon: UIImage?
    
    public var description: String {
        return name
    }
    
    public var debugDescription: String {
        return "[Mode | \(name) | \(id)]"
    }
    
    init(name: String) {
        self.id = "☠️"
        self.name = name
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
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
                let name = aDecoder.decodeObject(forKey: "name") as? String
            else {
                return nil
            }
            
            mode = Mode(id: id, name: name)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let mode = mode else {
                return
            }
            
            aCoder.encode(mode.id, forKey: "id")
            aCoder.encode(mode.name, forKey: "name")
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
