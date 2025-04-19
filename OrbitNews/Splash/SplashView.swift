//
//  SwiftUIView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import Lottie
import SwiftUI

/// A SwiftUI view representing the splash screen of the application.
///
/// This view displays an animated splash screen using a Lottie animation and transitions to the home screen
/// once the animation completes. It also initializes necessary data and dependencies required for the app's
/// main functionality.
///
/// - Note: The splash screen performs the following tasks:
///   1. Displays a Lottie animation named "Space".
///   2. Fetches articles asynchronously using the `ArticlesViewModel`.
///   3. Transitions to the `HomeView` once the animation finishes.
///
/// The view uses a `NavigationStack` to manage navigation and ensures that the transition to the home screen
/// is seamless. The `SQLManager` instance is passed to the `HomeView` to handle database operations.
///
/// Example:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         SplashView()
///     }
/// }
/// ```
struct SplashView: View {
    /// The navigation path used to manage transitions between views.
    @State private var path = NavigationPath()
    
    /// The view model responsible for fetching and managing articles.
    @StateObject private var viewModel = ArticlesViewModel()
    
    /// The manager class responsible for handling SQLite database operations.
    private let sqlManager = SQLManager()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Displays the Lottie animation and triggers navigation upon completion.
                LottieView(animation: .named("Space"))
                    .animationDidFinish { _ in
                        path.append("Home")
                    }
                    .animationSpeed(4.0)
                    .playing()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            // Fetches articles asynchronously when the view appears.
            .task {
                await viewModel.fetchArticles()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.splashBackgound)
            // Handles navigation to the home screen.
            .navigationDestination(for: String.self) { destination in
                if destination == "Home" {
                    HomeView(navigationPath: $path, viewModel: viewModel, sqlManager: sqlManager)
                                            .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
