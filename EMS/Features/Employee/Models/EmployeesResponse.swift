//
//  EmployeesResponse.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

// MARK: - Employees Response Model

struct EmployeesResponse: Codable {
    let status: Int?
    let message: String?
    let result: [EmployeesResult]?
    let error: ErrorResult?
}

// MARK: - Employees Result Model

struct EmployeesResult: Codable {
    let _id: String?
    let empNo: Int?
    let birthDate, firstName, lastName: String?
    let gender: String?
    let hireDate: String?
}
