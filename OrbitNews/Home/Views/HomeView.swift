//
//  HomeView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

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
