//
//  StringExtension.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 14/09/23.
//

import Foundation

extension String {
    // check for blank string
    var isBlank: Bool {
      return allSatisfy({ $0.isWhitespace })
    }
    
    // convert String to Date
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? Date()
    }
}
