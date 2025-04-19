//
//  LoadingView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 19/04/25.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            
            LottieView(animation: .named("Loading"))
                .looping()
                .frame(width: 150, height: 150)
            
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
    
}

#Preview {
    LoadingView()
}
