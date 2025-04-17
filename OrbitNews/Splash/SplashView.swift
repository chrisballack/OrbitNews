//
//  SwiftUIView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import Lottie
import SwiftUI

struct SwiftUIView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Contenido de Lottie y otros elementos
                LottieView(animation: .named("Space"))
                    .animationDidFinish { _ in
                        path.append("Home")
                    }
                    .animationSpeed(4.0)
                    .playing()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color("SplashBackgound"))
            .navigationDestination(for: String.self) { destination in
                if destination == "Home" {
                    HomeView(navigationPath: $path)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
