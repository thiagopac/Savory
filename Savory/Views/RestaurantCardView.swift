//
//  RestaurantCardView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    @State private var coverImageUrl: String?
    @Environment(FavoritesManager.self) private var favorites

    private let cardWidth: CGFloat = 180

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    imageArea
                        .frame(width: cardWidth, height: 128)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 128)

                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
                }

                Button {
                    favorites.toggle(restaurant)
                } label: {
                    Image(systemName: favorites.isFavorite(restaurant) ? "heart.fill" : "heart")
                        .font(.system(size: 13))
                        .foregroundStyle(favorites.isFavorite(restaurant) ? .red : .white)
                        .padding(7)
                        .background(.black.opacity(0.45))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 14, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 14
            ))

            VStack(alignment: .leading, spacing: 3) {
                Text(restaurant.restaurantName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(restaurant.type)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(restaurant.cityName)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text(restaurant.deliveryTime)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 10)
            .padding(.top, 9)
            .padding(.bottom, 12)
        }
        .frame(width: cardWidth)
        .background(Color.savoryCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
        .task {
            await loadCoverImage()
        }
    }

    @ViewBuilder
    private var imageArea: some View {
        if let urlStr = coverImageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().aspectRatio(contentMode: .fill)
                default:
                    cuisineGradient
                }
            }
        } else {
            cuisineGradient
        }
    }

    private var cuisineGradient: some View {
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
