//
//  ListView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI


/// A custom `PreferenceKey` used to track which item is currently visible in a scroll view.
///
/// - Important: This key is used internally by `VisibleItemModifier` to detect visible items and update the `visibleID` state.
struct VisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: Int? {
        nil
    }
    
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = value ?? nextValue()
    }
}

/// A view modifier that tracks the visibility of a specific item in a scroll view.
///
/// - Parameter id: A unique identifier for the item being tracked.
///
/// This modifier uses a `GeometryReader` to determine the visibility of the item and updates the `VisibilityPreferenceKey` with the provided `id`.
/// The `Color.clear` background ensures that the modifier does not visually alter the content.
///
/// - Important: This modifier is typically used in conjunction with a `PreferenceKey` (e.g., `VisibilityPreferenceKey`) to track visible items in a scrollable view.
///
/// Example usage:
///
/// ```swift
/// Text("Item 1")
///     .modifier(VisibleItemModifier(id: 1))
/// ```
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

/// Adds a modifier to the view that tracks its visibility in a scrollable container.
///
/// - Parameter id: A unique identifier for the view being tracked.
///
/// This method applies the `VisibleItemModifier` to the view, enabling it to report its visibility using the `VisibilityPreferenceKey`.
/// It is typically used in scrollable views (e.g., `ScrollView` or `List`) to detect which items are currently visible.
///
/// - Important: Ensure that the `VisibilityPreferenceKey` is properly implemented and used in conjunction with this method to track visibility.
///
/// Example usage:
///
/// ```swift
/// Text("Item 1")
///     .detectVisibility(id: 1)
/// ```
extension View {
    func detectVisibility(id: Int) -> some View {
        self.modifier(VisibleItemModifier(id: id))
    }
}

/// A view that displays a list or grid of articles, depending on the user's preference.
///
/// - Parameters:
///   - viewModel: An observed object of type `ArticlesViewModel` that provides the data for the articles.
///   - sqlManager: An observed object of type `SQLManager` that manages database operations for favorites.
///   - isFavorite: A Boolean value indicating whether the view is displaying favorite articles.
///   - articles: An array of `ResultsArticles` objects representing the articles to display.
///   - title: The title of the view, typically displayed in the navigation bar.
///
/// This view dynamically switches between a list layout and a grid layout based on the `isGridView` state variable.
/// It also includes functionality for detecting visible items, loading more articles as the user scrolls, and handling article taps.
/// If no articles are available, an `EmptyNews` view is displayed instead.
///
/// - Note: Ensure that the `ArticlesViewModel` and `SQLManager` classes are properly implemented and initialized before using this view.
///         Additionally, the `GridContentView` and `ListContentView` components should be defined elsewhere in the project.
///
/// Example usage:
///
/// ```swift
/// ListView(
///     viewModel: ArticlesViewModel(),
///     sqlManager: SQLManager(),
///     isFavorite: false,
///     articles: [],
///     title: NSLocalizedString("News", comment: "")
/// )
/// ```
struct ListView: View {
    @ObservedObject var viewModel: ArticlesViewModel
    @Binding var isGridView: Bool
    @Binding var scrollTarget: Int?
    @Binding var visibleID: Int?
    @State private var isShowingArticleDetail = false
    var sqlManager: SQLManager
    let isFavorite: Bool
    let articles: [ResultsArticles]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let title: String
    
    
    
    @State private var selectedArticle: ResultsArticles?
    
    var body: some View {
        if (articles.isEmpty){
            
            
            EmptyNews(withImage: !isFavorite, withbutton: !isFavorite, Title: isFavorite ? NSLocalizedString("No favorites", comment: "")  : NSLocalizedString("No news available", comment: ""), onTapRetry:
                        {
                Task{
                    await viewModel.fetchArticles(limit: 10)
                }
            })
            
            
        }else{
            
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
                            } onArticleTap: { article in
                                
                                let isFavorite = sqlManager.fetchArticle(by: article.id)
                                
                                selectedArticle = isFavorite != nil ? isFavorite : article
                                
                            }.accessibilityIdentifier("GridContentView")
                        
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
                            } onArticleTap: { article in
                                let isFavorite = sqlManager.fetchArticle(by: article.id)
                                selectedArticle = isFavorite != nil ? isFavorite : article
                            }.accessibilityIdentifier("ListContentView")
                    }
                }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ToggleGridViewButton(isGridView: $isGridView).accessibilityIdentifier("ToggleGridViewButton")
                    }
                }
                .onChange(of: isGridView) { newValue in
                    if let visibleID = visibleID {
                        scrollTarget = visibleID
                    }
                }
                .refreshable {
                    Task {
                        
                        if viewModel.searchQuery != "" {
                            
                            await viewModel.searchArticles()
                            
                        }else{
                            
                            await viewModel.fetchArticles(limit: 10)
                            
                        }
                        
                    }
                }
                .sheet(item: $selectedArticle) { Data in
                    
                    ArticleDetailView(article: Data) {
                        selectedArticle = nil
                    } onFavoritePress: {
                        let exists = sqlManager.fetchArticle(by: Data.id)
                        if exists != nil {
                            sqlManager.deleteFavorite(by: Data.id)
                        } else {
                            sqlManager.insertFavorites(article: Data)
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
}

/// A view that displays articles in a grid layout.
///
/// - Parameters:
///   - articles: An array of `ResultsArticles` objects representing the articles to display.
///   - scrollTarget: A binding to an integer that specifies the target item to scroll to.
///   - visibleID: A binding to an integer that tracks the currently visible item.
///   - onLoadMore: A closure invoked when the user scrolls near the end of the list to load more articles.
///   - onArticleTap: A closure invoked when an article is tapped.
///
/// This view uses a `LazyVGrid` to display articles in a two-column grid. It also includes functionality for detecting visible items and loading more articles as the user scrolls.
struct GridContentView: View {
    let articles: [ResultsArticles]
    @Binding var scrollTarget: Int?
    @Binding var visibleID: Int?
    var onLoadMore: () -> Void
    var onArticleTap: (ResultsArticles) -> Void
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(articles, id: \.id) { article in
                        GridItemView(article: article , onTap: { article in
                            if let article = article{
                                onArticleTap(article)
                            }
                            
                        })
                        .id(article.id)
                        .detectVisibility(id: article.id)
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

/// A view that displays articles in a list layout.
///
/// - Parameters:
///   - articles: An array of `ResultsArticles` objects representing the articles to display.
///   - scrollTarget: A binding to an integer that specifies the target item to scroll to.
///   - visibleID: A binding to an integer that tracks the currently visible item.
///   - onLoadMore: A closure invoked when the user scrolls near the end of the list to load more articles.
///   - onArticleTap: A closure invoked when an article is tapped.
///
/// This view uses a `List` to display articles in a single-column list. It also includes functionality for detecting visible items and loading more articles as the user scrolls.
struct ListContentView: View {
    let articles: [ResultsArticles]
    @Binding var scrollTarget: Int?
    @Binding var visibleID: Int?
    var onLoadMore: () -> Void
    var onArticleTap: (ResultsArticles) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(articles, id: \.id) { article in
                    ListItemView(article: article, onTap: { article in
                        if let article = article{
                            onArticleTap(article)
                        }
                        
                    })
                    .padding(.vertical, 4)
                    .id(article.id)
                    .detectVisibility(id: article.id)
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

/// A button that toggles between list and grid layouts.
///
/// - Parameter isGridView: A binding to a Boolean value that determines whether the grid layout is active.
///
/// This button displays an icon representing the current layout and toggles the layout when tapped.
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

#Preview {
    ListView(viewModel: ArticlesViewModel(),isGridView: .constant(false), scrollTarget: .constant(0),visibleID: .constant(0), sqlManager: SQLManager(), isFavorite: false, articles: [], title: "Noticias")
}
