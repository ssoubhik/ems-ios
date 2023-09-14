//
//  EmployeeViewModel.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation
import CoreData

// MARK: - Employee ViewModel Protocol

protocol EmployeeViewModel {
    func fetchEmployees() async
}

// MARK: - Employee ViewModel Implementation

@MainActor
final class EmployeeViewModelImpl: ObservableObject, EmployeeViewModel {
    // published properties
    @Published var apiState: APIState = .none
    @Published var employeeEntities: [EmployeeEntity] = []
    @Published var totalEmployeeCout = 0
    @Published var errorHandler = Handler()
    
    private let service: EmployeeService
    private let container: NSPersistentContainer
    
    init(service: EmployeeService) {
        // setup api service
        self.service = service
        
        // setup coredata
        self.container = NSPersistentContainer(name: "EmployeeContainer")
        self.container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData: \(error.localizedDescription)")
            }
        }
        
        // get employees from coredata
        getEmplyoyees()
    }
    
    // Method: get all employess
    func fetchEmployees() async {
        do {
            // get employess response
            let response = try await service.fetchEmployees()
            
            switch response.status {
            case 200:
                if let employees = response.result {
                    // call add employee and save employees data from api response to coredata
                    addEmployee(employees: employees)
                }
            default:
                // server error
                errorHandler.isPresented = true
                errorHandler.description = response.error?.message ?? StaticText.defaultError
            }
        } catch {
            // general error
            errorHandler.isPresented = true
            errorHandler.description = error.localizedDescription
        }
    }
    
    // Method: get employees from coredata
    func getEmplyoyees() {
        // create fetch request
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            // fetch data
            let allEmployees = try container.viewContext.fetch(request)
            
            // set total employee count
            totalEmployeeCout = allEmployees.count
            
            // set first 400 employees
            employeeEntities = allEmployees.prefix(400).map{ result in
                result
            }
        } catch {
            // show error
            errorHandler.isPresented = true
            errorHandler.description = error.localizedDescription
        }
    }
    
    // Method: add employees in coredata
    func addEmployee(employees: [EmployeesResult]) {
        employees.forEach { employee in
            let employeeEntity = EmployeeEntity(context: container.viewContext)
            employeeEntity.uid = employee._id
            employeeEntity.empNo = Int16(employee.empNo ?? 0)
            employeeEntity.firstName = employee.firstName
            employeeEntity.lastName = employee.lastName
            employeeEntity.birthDate = employee.birthDate
            employeeEntity.gender = employee.gender
            employeeEntity.hireDate = employee.hireDate
        }
        
        // call save data
        saveData()
    }
    
    // Method: save data in coredata
    func saveData() {
        do {
            // save data
            try container.viewContext.save()
            
            // call get employees to refetch new data
            getEmplyoyees()
        } catch {
            // show error
            errorHandler.isPresented = true
            errorHandler.description = error.localizedDescription
        }
    }
}
