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
    @State private var isGridViewHome = false
    @State private var isGridViewFavorites = false
    @FocusState private var isSearchFieldFocused: Bool
    @ObservedObject var viewModel: ArticlesViewModel
    @ObservedObject var sqlManager: SQLManager
    
    @State private var scrollTargetHome: Int?
    @State private var visibleIDHome: Int?
    @State private var scrollTargetFavorites: Int?
    @State private var visibleIDFavorites: Int?
    
    enum Tab {
        case home, search, favorites
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        if (viewModel.isLoading){
                            LoadingView()
                        }else{
                            ListView(viewModel: viewModel,isGridView: $isGridViewHome, scrollTarget:$scrollTargetHome, visibleID:$visibleIDHome,sqlManager: sqlManager, isFavorite: false, articles: viewModel.articles?.results ?? [], title: NSLocalizedString("News", comment: "")
                            )
                        }
                    case .search:
                        EmptyView()
                    case .favorites:
                        if (viewModel.isLoading){
                            LoadingView()
                        }else{
                            ListView(viewModel: viewModel,isGridView: $isGridViewFavorites,scrollTarget: $scrollTargetFavorites, visibleID: $visibleIDFavorites, sqlManager: sqlManager,isFavorite: true,articles: sqlManager.favorites, title: NSLocalizedString("Favorites", comment: ""))
                        }
                        
                        
                    }
                }
                
                if isSearching {
                    SearchBarView(
                        searchText: $searchText,
                        onSubmit: {
                            
                            if (selectedTab == .home){
                                viewModel.searchQuery = searchText
                                Task {
                                    await viewModel.searchArticles(withLoading: true)
                                }
                            }else{
                                
                                if (searchText == ""){
                                    sqlManager.fetchAllFavorites()
                                }else{
                                    
                                    sqlManager.searchFavorites(by: searchText)
                                    
                                }
                                
                                
                                
                            }
                            
                            isSearching = false
                        },
                        onCancel: {
                            isSearching = false
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: isSearching)
                    .accessibilityIdentifier("SearchBarView")
                    
                }else{
                    TabBarView(
                        selectedTab: selectedTab,
                        isSearching: isSearching,
                        onTabSelect: { selectedTab = $0; isSearching = false },
                        onSearchTap: { isSearching = true }
                    ).accessibilityIdentifier("TabBarView")
                }
                
            }.accessibilityIdentifier("HomeViewContent")
            
            
        }.accessibilityIdentifier("HomeViewRoot")
            .accessibility(addTraits: .isHeader)
        
    }
    
}

#Preview {
    HomeView(
        navigationPath: .constant(NavigationPath()),
        viewModel: ArticlesViewModel(), sqlManager: SQLManager()
    )
}
