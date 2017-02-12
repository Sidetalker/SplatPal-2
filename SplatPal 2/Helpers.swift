//
//  Helpers.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

// MARK: NSCoding for Swift Structs
// Taken from https://medium.com/@ryuichi/swift-struct-nscoding-107fc2d6ba5e#.ttwsxfpp6

protocol Encodable {
    var encoded: Decodable? { get }
}

protocol Decodable {
    var decoded: Encodable? { get }
}

extension Sequence where Iterator.Element: Encodable {
    var encoded: [Decodable] {
        return self.filter({ $0.encoded != nil }).map({ $0.encoded! })
    }
}

extension Sequence where Iterator.Element: Decodable {
    var decoded: [Encodable] {
        return self.filter({ $0.decoded != nil }).map({ $0.decoded! })
    }
}
