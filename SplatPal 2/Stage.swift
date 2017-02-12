//
//  Stage.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import UIKit

/// Splatoon stage (or stage)
public struct Stage: CustomStringConvertible {
    public internal(set) var id: String
    
    /// Localized name of the stage
    public internal(set) var name: String
    
    /// 580x326 px image of the stage
    public internal(set) var image: UIImage?
    
    public var description: String {
        return name
    }
    
    public var debugDescription: String {
        return "[Stage | \(name) | \(id)]"
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

extension Stage {
    class Coding: NSObject, NSCoding {
        let stage: Stage?
        
        init(stage: Stage) {
            self.stage = stage
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let id = aDecoder.decodeObject(forKey: "id") as? String,
                let name = aDecoder.decodeObject(forKey: "name") as? String
            else {
                return nil
            }
            
            stage = Stage(id: id, name: name)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let stage = stage else {
                return
            }
            
            aCoder.encode(stage.id, forKey: "id")
            aCoder.encode(stage.name, forKey: "name")
        }
    }
}

extension Stage: Encodable {
    var encoded: Decodable? {
        return Stage.Coding(stage: self)
    }
}

extension Stage.Coding: Decodable {
    var decoded: Encodable? {
        return self.stage
    }
}
