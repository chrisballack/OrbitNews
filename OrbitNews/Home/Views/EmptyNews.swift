//
//  EmptyNews.swift
//  OrbitNews
//
//  Created by Christians bonilla on 19/04/25.
//

import SwiftUI

struct EmptyNews: View {
    
    let withImage: Bool
    let withbutton: Bool
    let Title: String
    let onTapRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            if (withImage){
                Image("notNews")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            
            Text(Title)
                .font(.title3)
                .foregroundColor(.gray)
            
            if (withbutton){
                Button(action: {
                    onTapRetry()
                }) {
                    Text(NSLocalizedString("Retry", comment: ""))
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyNews(withImage: true, withbutton: true, Title: NSLocalizedString("No news available", comment: ""), onTapRetry: {
        
        print("works")
        
    })
}
