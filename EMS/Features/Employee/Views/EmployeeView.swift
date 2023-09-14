//
//  EmployeeView.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import SwiftUI

// MARK: - Employee View

struct EmployeeView: View {
    @StateObject private var employeeVM = EmployeeViewModelImpl(service: EmployeeServiceImpl())
    var body: some View {
        ZStack {
            if employeeVM.employeeEntities.isEmpty {
                // employee loading view
                ProgressView()
                    .task {
                        // call fetch employees api
                        await employeeVM.fetchEmployees()
                    }
            } else {
                // employee list view
                List {
                    // section: employee count
                    Section(StaticText.empCount) {
                        Text("\(StaticText.totalEmpFound): \(employeeVM.totalEmployeeCout)")
                    }
                    
                    // section: first 400 employee list
                    Section(StaticText.showingEmp) {
                        ForEach(employeeVM.employeeEntities) { employee in
                            NavigationLink {
                                // navigate to employee details view
                                EmployeeDetailsView(employee: employee)
                            } label: {
                                EmployeeListRow(employee: employee)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(StaticText.emplyees)
    }
}


// MARK: - Employee List Row View

struct EmployeeListRow: View {
    let employee: EmployeeEntity
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(employee.firstName ?? "") \(employee.lastName ?? "")")
                .font(.headline)
            
            Text("Joined on: \(employee.hireDate ?? "")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeView()
    }
}
