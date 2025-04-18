//
//  SwiftUIView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import Lottie
import SwiftUI

struct SplashView: View {
    @State private var path = NavigationPath()
    @StateObject private var viewModel = ArticlesViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                
                LottieView(animation: .named("Space"))
                    .animationDidFinish { _ in
                        path.append("Home")
                    }
                    .animationSpeed(4.0)
                    .playing()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            .task {
                await viewModel.fetchArticles()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.splashBackgound)
            .navigationDestination(for: String.self) { destination in
                if destination == "Home" {
                    HomeView(navigationPath: $path, viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
