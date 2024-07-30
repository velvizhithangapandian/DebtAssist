//
//  GoldLoanDetailView.swift
//  DebtAssist
//
//  Created by Divagar Gurusamy on 28/07/24.
//

import SwiftUI

struct GoldLoanDetailView: View {
    
    @State var principleAmount: Double = 237000
    @State var totalInterest: Double = 0
    @State var results: [GoldLoanResult]
    @State var formatter: DateFormatter = DateFormatter()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 12, content: {
                
                Image("Gold")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                
                Text("Gold Loan Detail")
                    .font(Font.system(size: 22, weight: .bold))
                
                Spacer()
                
                Button {
                    
                    dismiss()
                    
                } label: {
                    
                    Image("Close")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                }
                
            })
            .padding(20)
            
            List {
                
                ForEach(Array(results.enumerated()), id: \.offset) { (_, item) in
                    
                    ActionListSection(background: Color(red: 1.0, green: 0.91, blue: 0.76)) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("\(formatter.string(from: item.date))")
                                .font(Font.system(size: 14, weight: .bold))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Principle = \(item.principle, specifier: "%.2f")")
                            Text("Interest = \(item.interest, specifier: "%.2f")")
                            
                            if item.isFinal {
                                
                                Text("Closing Amount = \(item.remaining, specifier: "%.2f")")
                                
                            } else {
                                
                                Text("Remaining = \(item.remaining, specifier: "%.2f")")
                            }
                            
                        }
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundStyle(.black)
                        .listRowSeparator(.hidden)
                        .background(Color.clear)
                        .padding(.vertical, 12)
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            .listStyle(.inset)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .background(Color.primaryAppBackground)
            .onAppear {
                
                formatter.dateFormat = "MMM yyyy"
            }
            
            ZStack {
                
                Rectangle()
                    .fill(Color.cardPrimaryAppBackground)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    
                    Text("Total Interest Paid: \(totalInterest, specifier: "%.2f")")
                    Text("Total Amount Paid: \(totalInterest + principleAmount, specifier: "%.2f")")
                })
                .font(Font.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal], 20)
                .padding(.bottom, 40)
                
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(Color.primaryAppBackground)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    
    let results = [GoldLoanResult(principle: 1000, interest: 20, remaining: 1000, date: Date()), GoldLoanResult(principle: 1000, interest: 20, remaining: 1000, date: Date()), GoldLoanResult(principle: 1000, interest: 20, remaining: 1000, date: Date()), GoldLoanResult(principle: 1000, interest: 20, remaining: 1000, date: Date())]
    
    return GoldLoanDetailView(results: results)
}

/*
 import Foundation

 let headers = [
     "x-rapidapi-key": "3c690180bcmsh5a4782f0e792c56p1da8fdjsnb13fd1bc3ec6",
     "x-rapidapi-host": "gold-rates-india.p.rapidapi.com"
 ]

 let request = NSMutableURLRequest(url: NSURL(string: "https://gold-rates-india.p.rapidapi.com/api/gold-rates")! as URL,
                                         cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
 request.httpMethod = "GET"
 request.allHTTPHeaderFields = headers

 let session = URLSession.shared
 let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
         print(error as Any)
     } else {
         let httpResponse = response as? HTTPURLResponse
         print(httpResponse)
     }
 })

 dataTask.resume()
 */
