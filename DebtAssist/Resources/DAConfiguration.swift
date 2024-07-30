//
//  DAConfiguration.swift
//  DebtAssist
//
//  Created by Divagar Gurusamy on 30/07/24.
//

import Foundation
import SwiftUI

class DAConfiguration: ObservableObject {
    
    @Published var tintColor: Color = .blue
    @Published var language: DALanguage = .english
    
    func configureTheme(tint: Color) {
        
        tintColor = tint
    }
    
    func changeLanguage(type: DALanguage) {
        
        language = type
    }
}
