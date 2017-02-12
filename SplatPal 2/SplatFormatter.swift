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
    
    private let microDayTimeFormatter: DateFormatter
    
    private init() {
        microDayTimeFormatter = DateFormatter()
        
        microDayTimeFormatter.dateFormat = "E hh:mm"
    }
    
    func microDayTime(from date: Date) -> String {
        return microDayTimeFormatter.string(from: date)
    }
}
