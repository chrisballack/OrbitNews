//
//  SearchBarView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSubmit: () -> Void
    var onCancel: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            TextField("Buscar...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focused($isFocused)
                .onSubmit {
                    onSubmit()
                }

            if let onCancel = onCancel {
                Button("Cancelar") {
                    onCancel()
                    isFocused = false
                }
                .padding(.leading, 5)
            }
        }
        .padding()
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    SearchBarPreviewContainer()
}

struct SearchBarPreviewContainer: View {
    @State private var text = ""

    var body: some View {
        SearchBarView(
            searchText: $text,
            onSubmit: {
                print("Submitted: \(text)")
            },
            onCancel: {
                print("Cancelled")
            }
        )
    }
}

