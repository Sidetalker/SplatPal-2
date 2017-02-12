//
//  SplatFormatter.swift
//  SplatPal 2
//
//  Created by Kevin Sullivan on 2/11/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation

/// DateFormatters are expensive, this centralizes and caches them
class SplatFormatter {
    
    static let shared = SplatFormatter()
    
    /// Examples: "Tues 15:30", "Sun 01:10"
    private let microDayTimeFormatter: DateFormatter
    
    /// Examples: "01:02:03.456", "10:06:50.245"
    private let timestampFormatter: DateFormatter
    
    private init() {
        microDayTimeFormatter = DateFormatter()
        timestampFormatter = DateFormatter()
        
        microDayTimeFormatter.dateFormat = "E hh:mm"
        timestampFormatter.dateFormat = "HH:mm:ss.SSS"
    }
    
    func microDayTime(from date: Date) -> String {
        return microDayTimeFormatter.string(from: date)
    }
    
    func timestamp(from date: Date) -> String {
        return timestampFormatter.string(from: date)
    }
    
    var currentTimestamp: String {
        return timestamp(from: Date())
    }
}
