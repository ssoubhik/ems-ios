//
//  EmployeeDetailsView.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import SwiftUI

// MARK: - Employee Details View

struct EmployeeDetailsView: View {
    // observed object
    @ObservedObject var employeeVM: EmployeeViewModelImpl
    
    // employee object
    let employee: EmployeeEntity
    
    var body: some View {
        ZStack {
            switch employeeVM.apiState {
            case .none, .loading:
                // loading view
                ProgressView()
                    .frame(maxWidth: .infinity)
            case .finished:
                List {
                    // basic info section
                    Section(StaticText.basicInfo) {
                        // first name
                        BasicInfoRow(
                            key: StaticText.firstName,
                            value: employee.firstName ?? ""
                        )
                        
                        // last name
                        BasicInfoRow(
                            key: StaticText.lastName,
                            value: employee.lastName ?? ""
                        )
                        
                        // birth date
                        BasicInfoRow(
                            key: StaticText.birthDate,
                            value: employee.birthDate ?? ""
                        )
                        
                        // gender
                        BasicInfoRow(
                            key: StaticText.gender,
                            value: employee.gender ?? ""
                        )
                    }
                    
                    // employment section
                    Section(StaticText.empInfo) {
                        // employee no.
                        BasicInfoRow(
                            key: StaticText.empNo,
                            value: String(employee.empNo)
                        )
                        
                        // joining date
                        BasicInfoRow(
                            key: StaticText.joiningDate,
                            value: employee.hireDateStr ?? ""
                        )
                        
                        // time spent
                        BasicInfoRow(
                            key: StaticText.timeSpent,
                            value: employeeVM.getTotalTimeSpent()
                        )
                    }
                    
                    // salary info section
                    Section(StaticText.salaryInfo) {
                        // salary list
                        ForEach(employeeVM.salaries, id: \._id) { salary in
                            SalaryInfoRow(salary: salary)
                        }
                    }
                }
            }
        }
        .navigationTitle(StaticText.empDetails)
        .task {
            // call employee salary api
            await employeeVM.fetchEmployeeSalary(empNo: String(employee.empNo))
        }
    }
}

// MARK: - Basic Info Row View

struct BasicInfoRow: View {
    let key: String
    let value: String
    var body: some View {
        HStack {
            Text("\(key):")
            
            Text(value)
                .font(.headline)
        }
    }
}

// MARK: - Salary Info Row View

struct SalaryInfoRow: View {
    let salary: SalariesResult
    var body: some View {
        HStack {
            // from date
            Text(salary.fromDate ?? "")
                .font(.footnote)
            
            // arrow icon
            Image(systemName: StaticImage.icArrow)
                .font(.footnote.bold())
                .foregroundColor(.accentColor)
            
            // to date
            Text(salary.toDate ?? "")
                .font(.footnote)
            
            Spacer()
            
            // salary amount
            Text("₹\(salary.salary ?? 0)")
                .font(.headline)
        }
    }
}
