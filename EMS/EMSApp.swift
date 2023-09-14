//
//  EMSApp.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import SwiftUI

@main
struct EMSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                EmployeeView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
