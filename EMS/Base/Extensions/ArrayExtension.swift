//
//  ArrayExtension.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 14/09/23.
//

import Foundation

extension Array {
    // minimize array elements to first 400 items
    func minimized() -> Self {
        return self.prefix(400).map{ result in
            result
        }
    }
}
