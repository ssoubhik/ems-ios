//
//  EmployeeView.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import SwiftUI

// MARK: - Employee View

struct EmployeeView: View {
    // state object
    @StateObject private var employeeVM = EmployeeViewModelImpl(service: EmployeeServiceImpl())
    
    // state property
    @State private var showFilterSheet = false
    
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
                        Text("\(StaticText.totalEmpFound): \(employeeVM.getFilteredList().count)")
                    }
                    
                    // section: employee list
                    Section(employeeVM.getEmployeeSectionHeader()) {
                        ForEach(employeeVM.getFilteredList().minimized()) { employee in
                            NavigationLink {
                                // navigate to employee details view
                                EmployeeDetailsView(
                                    employeeVM: employeeVM,
                                    employee: employee
                                )
                            } label: {
                                EmployeeListRow(employee: employee)
                            }
                        }
                    }
                }
                .toolbar {
                    // filter button
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            // open filter sheet
                            showFilterSheet.toggle()
                        } label: {
                            Image(systemName: StaticImage.icFilter)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        // cancel filter button
                        if !employeeVM.filterDate.isBlank {
                            Button(StaticText.cancelFilter) {
                                // clear filter date
                                employeeVM.filterDate.removeAll()
                            }
                        }
                    }
                }
                .sheet(isPresented: $showFilterSheet) {
                    if #available(iOS 16, *) {
                        // open half sheet for iOS 16 and above
                        EmployeeFilterSheet(filterDate: $employeeVM.filterDate)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    } else {
                        // open full sheet for older iOS versions
                        EmployeeFilterSheet(filterDate: $employeeVM.filterDate)
                    }
                }
            }
        }
        .navigationTitle(StaticText.emplyees)
        .alert(StaticText.error, isPresented: $employeeVM.errorHandler.isPresented) {
            Button(StaticText.okay, role: .cancel) {}
        } message: {
            Text(employeeVM.errorHandler.description)
        }
    }
}

// MARK: - Employee List Row View

struct EmployeeListRow: View {
    let employee: EmployeeEntity
    var body: some View {
        VStack(alignment: .leading) {
            // fullname
            Text("\(employee.firstName ?? "") \(employee.lastName ?? "")")
                .font(.headline)
            
            // joining date
            Text("\(StaticText.joinedOn): \(employee.hireDateStr ?? "")")
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
