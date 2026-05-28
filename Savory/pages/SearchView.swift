//
//  SearchView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 24) {
            SearchBarView(text: $searchText)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.savoryOrange.opacity(0.3))

            Text("Search for restaurants or dishes")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
    }
}
