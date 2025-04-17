//
//  TabBarView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

struct TabBarView: View {
    let selectedTab: HomeView.Tab
    let isSearching: Bool
    let onTabSelect: (HomeView.Tab) -> Void
    let onSearchTap: () -> Void
    
    var body: some View {
        HStack {
            tabBarItem(icon: "newspaper", title: "News", tab: .home)
            Spacer()
            searchButton()
            Spacer()
            tabBarItem(icon: "suit.heart", title: "Favoritos", tab: .profile)
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
                    .foregroundColor(selectedTab == tab && !isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab && !isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
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
                    .foregroundColor(isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
                Text("Buscar")
                    .font(.caption)
                    .foregroundColor(isSearching ? Color("TabBarActive") : Color("TabBarUnActive"))
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
