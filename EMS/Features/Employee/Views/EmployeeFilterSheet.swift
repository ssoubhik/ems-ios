//
//  EmployeeFilterSheet.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 14/09/23.
//

import SwiftUI

// MARK: - Employee Filter Sheet View

struct EmployeeFilterSheet: View {
    // environment property
    @Environment(\.dismiss) var dismiss
    
    // data binding
    @Binding var filterDate: String
    
    // state property
    @State private var date = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // filter employees title
            Text(StaticText.empfilter)
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // filter date field
            DateFieldComponent(
                date: $date,
                placeHolder: StaticText.selectDate
            )
                    
            // filter by date button
            Button {
                // set filter date & dismiss sheet
                filterDate = date
                dismiss()
            } label: {
                Text(StaticText.filterByDate)
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(date.isBlank)
            .padding(.top, 30)

            Spacer()
        }
        .padding()
        .onAppear {
            date = filterDate
        }
    }
}

struct EmployeeFilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeFilterSheet(filterDate: .constant(""))
    }
}
