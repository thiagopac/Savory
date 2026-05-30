//
//  RestaurantRowView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant
    @State private var coverImageUrl: String?

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                if let urlStr = coverImageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().aspectRatio(contentMode: .fill)
                        default:
                            gradientThumb
                        }
                    }
                } else {
                    gradientThumb
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {
                Text(restaurant.restaurantName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(restaurant.type)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(restaurant.cityName)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(restaurant.deliveryTime)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Color(.systemBackground))
        .task { await loadCoverImage() }
    }

    private var gradientThumb: some View {
        LinearGradient(
            colors: cuisineGradientColors(for: restaurant.type),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func loadCoverImage() async {
        guard coverImageUrl == nil else { return }
        if let items = try? await APIService.fetchMenu(restaurantID: restaurant.restaurantID),
           let first = items.first(where: { $0.imageUrl != nil }) {
            coverImageUrl = first.imageUrl
        }
    }
}
