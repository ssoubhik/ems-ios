//
//  SalariesResponse.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 14/09/23.
//

import Foundation

// MARK: - Salaries Response Model

struct SalariesResponse: Codable {
    let status: Int?
    let message: String?
    let result: [SalariesResult]?
    let error: ErrorResult?
}

// MARK: - Salaries Result Model

struct SalariesResult: Codable {
    let _id: String?
    let empNo, salary: Int?
    let fromDate, toDate: String?
}
