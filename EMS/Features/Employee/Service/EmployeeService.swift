//
//  EmployeeService.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

// MARK: - Employee Service Protocol

protocol EmployeeService {
    func fetchEmployees() async throws -> EmployeesResponse
}

// MARK: - Employee Service Implementation

final class EmployeeServiceImpl: EmployeeService, RestAPIClient {
    // Method: fetch all employees
    func fetchEmployees() async throws -> EmployeesResponse {
        return try await callAPI(
            path: StaticUrl.employeesPath,
            method: .get
        )
    }
}
