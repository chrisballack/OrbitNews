//
//  SwiftUIView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import Lottie
import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            // Fullscreen Lottie background
            LottieView(animation: .named("Space"))
                .animationDidFinish { _ in
                    
                }
                .animationSpeed(4.0)
                .playing()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color("SplashBackgound"))
    }
}

#Preview {
    SwiftUIView()
}
