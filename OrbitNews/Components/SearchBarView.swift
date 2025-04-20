//
//  SearchBarView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

/// A customizable search bar view that allows users to input search queries and perform actions.
///
/// - Parameters:
///   - searchText: A binding to a string that represents the current text in the search bar.
///   - onSubmit: A closure invoked when the user submits the search query (e.g., by pressing "Return").
///   - onCancel: An optional closure invoked when the user cancels the search (e.g., by tapping a "Cancel" button).
///
/// This view provides a text field for entering search queries, along with an optional "Cancel" button.
/// The keyboard automatically appears when the view appears, and the search bar handles submission and cancellation actions.
///
/// - Important: Ensure that the `onSubmit` and `onCancel` closures are properly implemented to handle user interactions.
///
/// Example usage:
///
/// ```swift
/// SearchBarView(
///     searchText: $searchText,
///     onSubmit: {
///         print("User submitted search: \(searchText)")
///     },
///     onCancel: {
///         print("User canceled search")
///     }
/// )
/// ```
import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSubmit: () -> Void
    var onCancel: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField(NSLocalizedString("Search", comment: "") + "...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit()
                    }

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                    .transition(.opacity)
                }
            }

            if let onCancel = onCancel {
                Button(NSLocalizedString("Cancel", comment: "")) {
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
        .accessibilityIdentifier("SearchBarView")
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

