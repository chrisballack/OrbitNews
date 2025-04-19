//
//  ArticleDetailView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 18/04/25.
//

import SwiftUI

struct ArticleDetailView: View {
    
    let article_url: String
    var onDonePress: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: article_url) {
                    WebView(url: url)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text(NSLocalizedString("Invalid URL", comment: ""))
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(NSLocalizedString("Article", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        
                        onDonePress()
                    }
                }
            }
        }
    }
}



#Preview {
    ArticleDetailView(article_url:"", onDonePress: {
        print("")
    })
}
