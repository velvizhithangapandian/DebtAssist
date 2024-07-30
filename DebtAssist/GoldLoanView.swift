//
//  GoldLoanView.swift
//  MyStories
//
//  Created by Divagar Gurusamy on 28/07/24.
//

import SwiftUI

struct GoldLoanView: View {
    
    @FocusState private var isFocused: Bool
    @State var interestRate: Double = 8.9
    @State var principleAmount: Double = 237000
    @State var monthlyEMI: Double = 3000
    @State private var totalInterest: Double = 0
    @StateObject var model: GoldLoanModel = GoldLoanModel()
    @State var formatter = DateFormatter()
    @State private var showDetail: Bool = false
    @State var currentBonus: Double = 3_00_000
    @State var initialBonus: Double = 3_00_000
    @State var currentEMI: Double = 30_000
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack(spacing: 12, content: {
                
                Image("Gold")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                
                Text("Gold Loan")
                    .font(Font.system(size: 22, weight: .bold))
                
                Spacer()
            })
            .padding(.bottom)
            
            InputContainer(name: "Principle:", amount: $principleAmount, range: 0...1000000)
            
            InputContainer(name: "Interest Rate:", amount: $interestRate, range: 1...20, step: 1)
            
            InputContainer(name: "Monthly EMI:", amount: $monthlyEMI, range: 0...100000)
            
            Spacer()
            
            Button {
                
                calculateEMI()
                
            } label: {
                
                Text("Calculate Loan")
                    .padding(.horizontal, 22)
                    .font(Font.system(size: 14, weight: .semibold))
            }
            .frame(height: 45)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(20)
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            
            GoldLoanDetailView(principleAmount: principleAmount, totalInterest: totalInterest, results: model.results, formatter: formatter)
        })
        .padding(20)
        .onAppear {
            
            formatter.dateFormat = "MMM yyyy"
            print(calculateGoldBuy(emi: currentEMI, date: addMonth(to: Date()), gold: 56.5, bonus: currentBonus))
            currentBonus = initialBonus
            calculateLoanClose()
        }
        .keyboardType(.numberPad)
        .focused($isFocused)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isFocused = false
                }
            }
        }
    }
    
    func getIncrementDate(currentDate: Date, formatter: DateFormatter) -> Date? {
        
        return Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
    }
    
    func getMonthlyEMI(principal: Double, interest: Double, tenure: Double) -> Double {
        
        let r = interest / 1200 // Monthly interest rate
        let emi = principal * r * pow(1 + r, tenure) / (pow(1 + r, tenure) - 1)
        return emi
    }
    
    func calculateEMI() {
        
        var results: [GoldLoanResult] = []
        totalInterest = 0
        var principle = principleAmount
        var totalMonth = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        var currentDate = Date()
        
        while principle > 0 {
            
            totalMonth += 1
            
            if let date = getIncrementDate(currentDate: currentDate, formatter: formatter) {
                
                currentDate = date
            }
            
            let currentInterest = getMonthlyIntrest(principle: principle)
            totalInterest += currentInterest
            let dueAmount = monthlyEMI - currentInterest
            let newPrinciple = principle - dueAmount
            principle = newPrinciple
            results.append(GoldLoanResult(principle: dueAmount, interest: currentInterest, remaining: principle, date: currentDate))
            
            if principle <= monthlyEMI {
                
                if let date = getIncrementDate(currentDate: currentDate, formatter: formatter) {
                    
                    currentDate = date
                }
                
                let currentInterest = getMonthlyIntrest(principle: principle)
                
                results.append(GoldLoanResult(principle: newPrinciple, interest: currentInterest, remaining: currentInterest + newPrinciple, date: currentDate, isFinal: true))
                model.results = results
                showDetail = true
                break
            }
        }
    }
    
    func getMonthlyIntrest(principle: Double) -> Double {
        
        principle * (interestRate / 1200)
    }
    
    func addMonth(to date: Date) -> Date {
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        // Define the date components to add (1 month)
        var dateComponents = DateComponents()
        dateComponents.month = 1
        
        // Add the date components to the given date
        guard let newDate = calendar.date(byAdding: dateComponents, to: date) else { return Date() }
        
        return newDate
    }
    
    func isDateInMonth(date: Date, month: Int) -> Bool {
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.month], from: date)
        return dateComponents.month == month
    }
    
    func isDateIn(date: Date, month: Int, year: Int) -> Bool {
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.month, .year], from: date)
        return dateComponents.month == month && dateComponents.year == year
    }
    
    func calculateGoldBuy(emi: Double, date: Date, gold: Double, bonus: Double) -> [String] {
        
        var currentEMI = emi
        var result: [String] = []
        let totalPrice: Double = 8000 * gold * 8 // 8000 * 56.5 * 8
        var currentBonus: Double = bonus
        
        var currentPrice: Double = 0
        
        var currentDate = date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        while currentPrice < totalPrice {
            
            if isDateIn(date: currentDate, month: 3, year: 2026) {
                
                currentEMI += self.currentEMI
                let item = "EMI Extra 30_000 and current emi = \(currentEMI)"
                result.append(item)
            }
            
            currentPrice += currentEMI
            
            if isDateInMonth(date: currentDate, month: 5) {
                
                currentPrice += currentBonus
                
                let item = "PSP \(currentBonus)"
                result.append(item)
                
                currentBonus += 40_000
            }
            
            if isDateIn(date: currentDate, month: 2, year: 2026) {
                
                currentPrice += 6_81_000
                let item = "Fund Added 6_81_000"
                result.append(item)
            }
            
            let item = "Date is \(formatter.string(from: currentDate)) currentPrice = \(currentPrice)"
            result.append(item)
            currentDate = addMonth(to: currentDate)
        }
        
        self.currentBonus = currentBonus
        return result
    }
    
    func calculateLoanClose() -> [String] {
        
        var currentEMI = self.currentEMI
        let closeUsingGold: Double = (25 * 8 * 6200) - 8_25_000
        var result: [String] = []
        var totalPrice: Double = 23_68_000 - closeUsingGold
        let afterLoanClose: Double = 25 * 8 * 8000
        let interestRate: Double = 12
        var currentBonus: Double = self.currentBonus
        var currentDate = addMonth(to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        while 0 < totalPrice {
            
            if isDateIn(date: currentDate, month: 3, year: 2026) {
                
                currentEMI += currentEMI
                let item = "EMI Extra 30_000 and current emi = \(currentEMI)"
                result.append(item)
            }
            
            let currentInterest = (totalPrice * (interestRate / 12)) / 100
            totalPrice -= (currentEMI - currentInterest)
            
            if isDateInMonth(date: currentDate, month: 5) {
                
                totalPrice -= (currentBonus - currentInterest)
                currentBonus += 40_000
                
                let item = "PSP \(currentBonus)"
                result.append(item)
            }
            
            if isDateIn(date: currentDate, month: 2, year: 2026) {
                
                totalPrice -= (6_81_000 - currentInterest)
                let item = "Fund Added 6_81_000"
                result.append(item)
            }
            
            if totalPrice <= 0 {
                
                if abs(totalPrice) > afterLoanClose {
                    
                    var inHandAmount = abs(totalPrice) - afterLoanClose
                    result.append("Loan closed and previous due \(afterLoanClose) also done. \(inHandAmount) in your hand.")
                    
                } else {
                    
                    let remainingDue = afterLoanClose - abs(totalPrice)
                    result.append("Loan closed and remaining = \(remainingDue)")
                    let goldResults = calculateGoldBuy(emi: currentEMI, date: addMonth(to: currentDate), gold: remainingDue / 8000, bonus: currentBonus)
                    result.append(contentsOf: goldResults)
                }
            } else {
                
                let item = "Date is \(formatter.string(from: currentDate)) currentPrice = \(totalPrice) currentInterest = \(currentInterest)"
                result.append(item)
                currentDate = addMonth(to: currentDate)
            }
        }
        
        return result
    }
}

#Preview {
    
    ContentS()
    //    GoldLoanView()
}

struct InputContainer: View {
    
    @State var name: String
    @Binding var amount: Double
    @State var range: ClosedRange<Double>
    @State var step: Double = 1000
    
    var body: some View {
        
        VStack(spacing: 20, content: {
            
            HStack(spacing: 8, content: {
                
                Text(name)
                
                TextField("Enter here", value: $amount, format: .number)
            })
            .font(Font.system(size: 16, weight: .bold))
            
            Slider(value: $amount, in: range, step: step)
                .frame(height: 45)
        })
    }
}

struct GoldLoanResult: Identifiable {
    
    var id: UUID = UUID()
    var principle: Double
    var interest: Double
    var remaining: Double
    var date: Date
    var isFinal: Bool = false
}

struct ContentS: View {
    var body: some View {
        
        Text("H")
    }
}

public struct ActionListSection<Content: View>: View {
    
    public var background: Color
    
    @ViewBuilder public let content: Content
    
    public var body: some View {
        
        Section {
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    
                    content
                }
                .background(Color.clear)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .listRowSeparator(.hidden)
            }
            .background(background)
            .cornerRadius(26)
            .padding(.vertical, 12)
            .listRowSeparator(.hidden)
            
        }
        .listRowInsets(EdgeInsets())
        .background(Color.primaryAppBackground)
    }
}

class GoldLoanModel: ObservableObject {
    
    @Published var results: [GoldLoanResult] = []
}

enum BankLoanType: String {
    
    case personal = "Personal Loan"
    case home = "Home Loan"
    case car = "Car Loan"
    case bike = "Bike Loan"
    case property = "Property Against Loan"
}

struct BankLoan {
    
    var type: BankLoanType
}
