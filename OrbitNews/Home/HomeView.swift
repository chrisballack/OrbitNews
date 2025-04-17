//
//  HomeView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedTab: Tab = .home
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    enum Tab {
        case home, search, profile
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        ListView(title: "Noticias")
                    case .search:
                        EmptyView()
                    case .profile:
                        ListView(title: "Favoritos")
                    }
                }
                Spacer()
                
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
                    .foregroundColor(selectedTab == tab && !isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab && !isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
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
                Text("Buscar")
                    .font(.caption)
                    .foregroundColor(isSearching ? .tabBarActive : .tabBarUnActive)
            }
        }
    }
}

#Preview {
    HomeView(navigationPath: .constant(NavigationPath()))
}
