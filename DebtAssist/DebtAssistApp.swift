//
//  DebtAssistApp.swift
//  DebtAssist
//
//  Created by Divagar Gurusamy on 28/07/24.
//

import SwiftUI

@main
struct DebtAssistApp: App {
    var body: some Scene {
        WindowGroup {
            GoldLoanView()
                .background(Color.primaryAppBackground)
        }
    }
}
