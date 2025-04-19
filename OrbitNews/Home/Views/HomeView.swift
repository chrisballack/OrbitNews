//
//  HomeView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

/// A view that represents the main interface of the application, including navigation between tabs and search functionality.
///
/// - Parameters:
///   - navigationPath: A binding to a `NavigationPath` object that manages the app's navigation stack.
///   - viewModel: An observed object of type `ArticlesViewModel` that provides data for the "News" tab.
///   - sqlManager: An observed object of type `SQLManager` that manages database operations for favorites.
///
/// This view consists of three main tabs: "Home", "Search", and "Favorites". The currently selected tab is determined by the `selectedTab` state variable.
/// When the "Search" tab is active, a search bar is displayed, allowing users to input search queries. The `isSearching` state variable controls the visibility of the search bar.
///
/// - Important: Ensure that the `ArticlesViewModel` and `SQLManager` classes are properly implemented and initialized before using this view.
///              Additionally, the `ListView` component should be defined elsewhere in the project.
///
/// - Note: The `Tab` enum defines the possible tabs in the view: `.home`, `.search`, and `.favorites`.
///
/// Example usage:
///
/// ```swift
/// HomeView(
///     navigationPath: .constant(NavigationPath()),
///     viewModel: ArticlesViewModel(),
///     sqlManager: SQLManager()
/// )
/// ```
struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedTab: Tab = .home
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool
    @ObservedObject var viewModel: ArticlesViewModel
    @ObservedObject var sqlManager: SQLManager
    
    enum Tab {
        case home, search, favorites
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        ListView(viewModel: viewModel, sqlManager: sqlManager, isFavorite: false, articles: viewModel.articles?.results ?? [], title: NSLocalizedString("News", comment: "")
                        )
                    case .search:
                        EmptyView()
                    case .favorites:
                        ListView(viewModel: viewModel, sqlManager: sqlManager,isFavorite: true,articles: sqlManager.favorites, title: NSLocalizedString("Favorites", comment: "")).onAppear {
                            sqlManager.fetchAllFavorites()
                        }
                        
                    }
                }
                
                if isSearching {
                    SearchBarView(
                        searchText: $searchText,
                        onSubmit: {
                            print("buscare ", searchText )
                            isSearching = false
                        },
                        onCancel: {
                            isSearching = false
                            searchText = ""
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: isSearching)
                }else{
                    TabBarView(
                        selectedTab: selectedTab,
                        isSearching: isSearching,
                        onTabSelect: { selectedTab = $0; isSearching = false },
                        onSearchTap: { isSearching = true }
                    )
                }
                
            }
            
            
        }
        
    }
    
    @ViewBuilder
    private func tabBarItem(icon: String, title: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
            isSearching = false
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
    
    @ViewBuilder
    private func searchButton() -> some View {
        Button(action: {
            isSearching = true
            selectedTab = .home
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
    HomeView(
        navigationPath: .constant(NavigationPath()),
        viewModel: ArticlesViewModel(), sqlManager: SQLManager()
    )
}
