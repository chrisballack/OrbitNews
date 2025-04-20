//
//  LoadingView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 19/04/25.
//

import SwiftUI
import Lottie

/// A view that displays a loading animation and message, typically used to indicate ongoing background tasks.
///
/// This view centers a looping Lottie animation along with a "Loading..." text message. It is designed to be flexible and adapt to the available screen space,
/// ensuring it remains visually centered regardless of the device or orientation.
///
/// - Important: Ensure that the `LottieView` component is properly implemented and that the "Loading" animation asset is included in your project.
///              Additionally, this view uses `.frame(maxWidth: .infinity, maxHeight: .infinity)` to ensure it expands to fill the available space.
///
/// Example usage:
///
/// ```swift
/// LoadingView()
/// ```
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
        
    }
    
}

#Preview {
    LoadingView()
}
