//
//  ListView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI
// MARK: - Modelo

struct Article: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let author: String
    let date: String
    let imageName: String
}

let sampleArticles = [
    Article(category: "Politics", title: "Meta donates $1 million to Trump’s inaugural fund: Reute...", author: "Aisha Grant", date: "Dec 12, 2024", imageName: "defaultImage"),
    Article(category: "Technology", title: "Former OpenAI researcher and whistleblower found d...", author: "Brandon Siphron", date: "Dec 12, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage"),
    Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "defaultImage")
]


// MARK: - Preferencia para saber qué item es visible

struct VisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: UUID?
    
    static func reduce(value: inout UUID?, nextValue: () -> UUID?) {
        value =   value ?? nextValue()
    }
}

struct VisibleItemModifier: ViewModifier {
    let id: UUID
    
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
    func detectVisibility(id: UUID) -> some View {
        self.modifier(VisibleItemModifier(id: id))
    }
}

// MARK: - Main View

struct ListView: View {
    
    @State private var isGridView = false
    @State private var scrollTarget: UUID?
    @State private var visibleID: UUID?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let title: String
    
    var body: some View {
        NavigationView {
            Group {
                if isGridView {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(sampleArticles) { article in
                                    GridItemView(article: article)
                                        .id(article.id)
                                        .detectVisibility(id: article.id)
                                }
                            }
                            .padding()
                        }
                        .onPreferenceChange(VisibilityPreferenceKey.self) { value in
                            visibleID = value
                        }
                        .onAppear {
                            if let target = scrollTarget {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo(target, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ScrollViewReader { proxy in
                        List {
                            ForEach(sampleArticles) { article in
                                ListItemView(article: article)
                                    .padding(.vertical, 4)
                                    .id(article.id)
                                    .detectVisibility(id: article.id)
                            }
                        }
                        .listStyle(.plain)
                        .onPreferenceChange(VisibilityPreferenceKey.self) { value in
                            visibleID = value
                        }
                        .onAppear {
                            if let target = scrollTarget {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo(target, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        scrollTarget = visibleID
                        withAnimation {
                            isGridView.toggle()
                        }
                    }) {
                        Image(systemName: isGridView ? "rectangle.grid.1x2" : "rectangle.grid.2x2")
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ListView(title: "Noticias")
}
