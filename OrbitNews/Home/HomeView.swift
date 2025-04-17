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

    enum Tab {
        case home, search, profile
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        ListView()

                    case .search:
                        VStack {
                            Text("Buscar")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))

                    case .profile:
                        VStack {
                            Text("Perfil")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                    }
                }
                
                HStack {
                    tabBarItem(icon: "newspaper", title: "News", tab: .home)
                    Spacer()
                    tabBarItem(icon: "magnifyingglass", title: "Buscar", tab: .search)
                    Spacer()
                    tabBarItem(icon: "suit.heart", title: "Favoritos", tab: .profile)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .background(Color(.black))
                
            }
            
        }
        
        
    }

    @ViewBuilder
    private func tabBarItem(icon: String, title: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? Color("TabBarActive") : Color("TabBarUnActive"))
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? Color("TabBarActive") : Color("TabBarUnActive"))
            }
        }
    }
}

#Preview {
    HomeView(navigationPath: .constant(NavigationPath()))
}
