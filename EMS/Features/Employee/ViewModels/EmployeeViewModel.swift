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
    func getEmplyoyees() async
    func getFilteredList() async -> [EmployeeEntity]
    func fetchEmployeeSalary(empNo: String) async
    func getTotalTimeSpent() async -> String
    func getEmployeeSectionHeader() async -> String
}

// MARK: - Employee ViewModel Implementation

@MainActor
final class EmployeeViewModelImpl: ObservableObject, EmployeeViewModel {
    // published properties
    @Published var apiState: APIState = .none
    @Published var employeeEntities: [EmployeeEntity] = []
    @Published var salaries: [SalariesResult] = []
    @Published var filterDate = ""
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
                        
            // set all employees sorted by emp_no
            employeeEntities = allEmployees.sorted { $0.empNo < $1.empNo }
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
            employeeEntity.hireDateStr = employee.hireDate
            employeeEntity.hireDate = employee.hireDate?.toDate()
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
    
    // Method: filter employees list by hiredate
    func getFilteredList() -> [EmployeeEntity] {
        if !filterDate.isBlank {
            let date = filterDate.toDate()
            return employeeEntities.filter { $0.hireDate ?? Date() > date }
        }
        
        return employeeEntities
    }
    
    // Method: get salaries of an employee
    func fetchEmployeeSalary(empNo: String) async {
        defer {
            // stop loader
            apiState = .finished
        }
        
        do {
            // start loader
            apiState = .loading
            
            // get salaries response
            let response = try await service.fetchEmployeeSalary(empNo: empNo)
            
            switch response.status {
            case 200:
                // set salaries array
                if let salaries = response.result  {
                    self.salaries = salaries.sorted { ($0.salary ?? 0) < ($1.salary ?? 0)}
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
    
    // Method: calculate total time spent
    func getTotalTimeSpent() -> String {
        let fromDate = salaries.first?.fromDate?.toDate() ?? Date()
        let toDate = salaries.last?.toDate?.toDate() ?? Date()
        let diffs = Calendar.current.dateComponents([.year, .month, .day], from: fromDate, to: toDate)
       
        return "\(diffs.year ?? 0) Years \(diffs.month ?? 0) Months"
    }
    
    // Method: get employee section header
    func getEmployeeSectionHeader() -> String {
        return "Showing \(getFilteredList().minimized().count) out of \(getFilteredList().count) Employees"
    }
}
