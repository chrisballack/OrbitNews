//
//  TabBarView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

/// A custom tab bar view that provides navigation between different sections of the app.
///
/// - Parameters:
///   - selectedTab: The currently selected tab in the tab bar.
///   - isSearching: A Boolean value indicating whether the search mode is active.
///   - onTabSelect: A closure invoked when a tab is selected. It receives the selected tab as a parameter.
///   - onSearchTap: A closure invoked when the search button is tapped.
///
/// This view consists of three main components: a "News" tab, a search button, and a "Favorites" tab.
/// The appearance of each component dynamically changes based on the `selectedTab` and `isSearching` states.
/// Active tabs or buttons are highlighted with the `.tabBarActive` color, while inactive ones use `.tabBarUnActive`.
///
/// - Note: Ensure that the `HomeView.Tab` enum and the color constants `.tabBarActive` and `.tabBarUnActive`
///         are properly defined elsewhere in the project.
///
/// Example usage:
///
/// ```swift
/// TabBarView(
///     selectedTab: .home,
///     isSearching: false,
///     onTabSelect: { tab in
///         print("Selected tab: \(tab)")
///     },
///     onSearchTap: {
///         print("Search button tapped")
///     }
/// )
/// ```
struct TabBarView: View {
    let selectedTab: HomeView.Tab
    let isSearching: Bool
    let onTabSelect: (HomeView.Tab) -> Void
    let onSearchTap: () -> Void
    
    var body: some View {
        HStack {
            tabBarItem(icon: "newspaper", title: NSLocalizedString("News", comment: ""), tab: .home)
            Spacer()
            searchButton()
            Spacer()
            tabBarItem(icon: "suit.heart", title: NSLocalizedString("Favorites", comment: ""), tab: .favorites)
        }
        .padding(.horizontal, 50)
        .padding(.top, 10)
        .background(Color(.black))
    }
    
    private func tabBarItem(icon: String, title: String, tab: HomeView.Tab) -> some View {
        Button(action: {
            onTabSelect(tab)
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(selectedTab == tab && !isSearching ? .tabBarActive : .tabBarUnActive)
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab && !isSearching ? .tabBarActive : .tabBarUnActive)
            }
        }
    }
    
    private func searchButton() -> some View {
        Button(action: {
            onSearchTap()
        }) {
            VStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSearching ? .tabBarActive : .tabBarUnActive)
                Text(NSLocalizedString("Search", comment: ""))
                    .font(.caption)
                    .foregroundColor(isSearching ? .tabBarActive : .tabBarUnActive)
            }
        }
    }
}


#Preview {
    TabBarView(
        selectedTab: .home,
        isSearching: false,
        onTabSelect: { _ in },
        onSearchTap: {}
    )
    .padding()
}
