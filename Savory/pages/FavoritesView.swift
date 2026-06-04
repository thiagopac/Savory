//
//  FavoritesView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        Group {
            if favorites.favorites.isEmpty {
                emptyView
            } else {
                favoritesList
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
    }

    private var favoritesList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text("\(favorites.favorites.count) saved restaurant\(favorites.favorites.count == 1 ? "" : "s")")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 14)

                LazyVStack(spacing: 14) {
                    ForEach(favorites.favorites) { restaurant in
                        NavigationLink {
                            RestaurantDetailView(restaurant: restaurant)
                        } label: {
                            FavoriteCard(restaurant: restaurant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.savoryOrangeSoft)
                    .frame(width: 110, height: 110)
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.savoryOrange.opacity(0.5))
            }

            VStack(spacing: 8) {
                Text("No favorites yet")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
                Text("Tap the heart on any restaurant\nto save it here")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
}

// MARK: - Favorite card

struct FavoriteCard: View {
    let restaurant: Restaurant
    @Environment(FavoritesManager.self) private var favorites
    @State private var coverImageUrl: String?

    var body: some View {
        HStack(spacing: 0) {
            imageArea
                .frame(width: 110, height: 110)
                .clipped()
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 16, bottomLeadingRadius: 16,
                    bottomTrailingRadius: 0, topTrailingRadius: 0
                ))

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(restaurant.restaurantName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(restaurant.type)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.system(size: 12, weight: .semibold))
                        }
                        Text("·")
                            .foregroundStyle(Color(.tertiaryLabel))
                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                            Text(restaurant.deliveryTime)
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 10))
                            .foregroundStyle(.savoryOrange)
                        Text(restaurant.cityName)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)

                HStack {
                    Text(restaurant.priceRange)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGroupedBackground))
                        .clipShape(Capsule())

                    Spacer()

                    Button {
                        favorites.toggle(restaurant)
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.red)
                            .frame(width: 36, height: 36)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
        .frame(height: 110)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .task { await loadCover() }
    }

    @ViewBuilder
    private var imageArea: some View {
        if let urlStr = coverImageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
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

    private func loadCover() async {
        guard coverImageUrl == nil else { return }
        if let items = try? await APIService.fetchMenu(restaurantID: restaurant.restaurantID),
           let first = items.first(where: { $0.imageUrl != nil }) {
            coverImageUrl = first.imageUrl
        }
    }
}
