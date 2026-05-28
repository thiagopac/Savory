//
//  FavoritesView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "heart.slash")
                .font(.system(size: 56))
                .foregroundStyle(.savoryOrange.opacity(0.3))

            Text("No favorites yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)

            Text("Save your favorite restaurants here")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
    }
}
