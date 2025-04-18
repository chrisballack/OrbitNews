//
//  ListView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI


// MARK: - Preferencia para saber qué item es visible

struct VisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: Int? {
        nil
    }
    
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = value ?? nextValue()
    }
}


struct VisibleItemModifier: ViewModifier {
    let id: Int
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: VisibilityPreferenceKey.self, value: id)
                }
            )
    }
}

extension View {
    func detectVisibility(id: Int) -> some View {
        self.modifier(VisibleItemModifier(id: id))
    }
}

// MARK: - Main View

struct ListView: View {
    @ObservedObject var viewModel: ArticlesViewModel
    @State private var isGridView = false
    @State private var scrollTarget: Int?
    @State private var visibleID: Int?
    let articles: [ResultsArticles]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let title: String
    
    
    var body: some View {
        NavigationView {
            Group {
                if isGridView {
                    GridContentView(
                        articles: articles,
                        scrollTarget: $scrollTarget,
                        visibleID: $visibleID) {
                            if (!viewModel.isLoading){
                                Task {
                                    await viewModel.loadMoreArticles()
                                }
                            }
                        }
                } else {
                    ListContentView(
                        articles: articles,
                        scrollTarget: $scrollTarget,
                        visibleID: $visibleID) {
                            if (!viewModel.isLoading){
                                Task {
                                    await viewModel.loadMoreArticles()
                                }
                            }
                        }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToggleGridViewButton(isGridView: $isGridView)
                }
            }
            .onChange(of: isGridView) { newValue in
                if let visibleID = visibleID {
                    scrollTarget = articles.first { $0.id == visibleID }?.id
                }
            }.refreshable {
                Task {
                    await viewModel.fetchArticles(limit: 10)
                }
            }
        }
    }
}

struct GridContentView: View {
    let articles: [ResultsArticles]
    @Binding var scrollTarget: Int?
    @Binding var visibleID: Int?
    var onLoadMore: () -> Void
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(articles, id: \.id) { article in
                        GridItemView(article: article)
                            .id(article.id)
                            .detectVisibility(id: article.id ?? 0)
                            .onAppear {
                                
                                if article.id == articles.last?.id ||
                                    articles.firstIndex(where: { $0.id == article.id }) ?? 0 > articles.count - 4 {
                                    onLoadMore()
                                }
                            }
                    }
                }
                .padding()
            }
            .onPreferenceChange(VisibilityPreferenceKey.self) { value in
                visibleID = value
            }
            .onAppear {
                scrollToTarget(proxy: proxy)
            }
        }
    }
    
    private func scrollToTarget(proxy: ScrollViewProxy) {
        if let target = scrollTarget {
            DispatchQueue.main.async {
                withAnimation {
                    proxy.scrollTo(target, anchor: .top)
                }
            }
        }
    }
}

struct ListContentView: View {
    let articles: [ResultsArticles]
    @Binding var scrollTarget: Int?
    @Binding var visibleID: Int?
    var onLoadMore: () -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(articles, id: \.id) { article in
                    ListItemView(article: article)
                        .padding(.vertical, 4)
                        .id(article.id)
                        .detectVisibility(id: article.id ?? 0)
                        .onAppear {
                            
                            if article.id == articles.last?.id ||
                                articles.firstIndex(where: { $0.id == article.id }) ?? 0 > articles.count - 4 {
                                onLoadMore()
                            }
                        }
                }
            }
            .listStyle(.plain)
            .onPreferenceChange(VisibilityPreferenceKey.self) { value in
                visibleID = value
            }
            .onAppear {
                scrollToTarget(proxy: proxy)
            }
        }
    }
    
    private func scrollToTarget(proxy: ScrollViewProxy) {
        if let target = scrollTarget {
            DispatchQueue.main.async {
                withAnimation {
                    proxy.scrollTo(target, anchor: .top)
                }
            }
        }
    }
}

struct ToggleGridViewButton: View {
    @Binding var isGridView: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isGridView.toggle()
            }
        }) {
            Image(systemName: isGridView ? "rectangle.grid.1x2" : "rectangle.grid.2x2")
        }
    }
}

// MARK: - Preview

#Preview {
    ListView(viewModel: ArticlesViewModel(), articles: [], title: "Noticias")
}
