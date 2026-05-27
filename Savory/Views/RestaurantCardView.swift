import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    @State private var isFavorite = false
    @State private var coverImageUrl: String?
    @State private var imageLoaded = false

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
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 13))
                        .foregroundStyle(isFavorite ? .red : .white)
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
            colors: gradientColors(for: restaurant.type),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func gradientColors(for type: String) -> [Color] {
        let t = type.lowercased()
        if t.contains("biryani") { return [Color(red: 0.9, green: 0.6, blue: 0.15), Color(red: 0.75, green: 0.4, blue: 0.08)] }
        if t.contains("south indian") { return [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.1, green: 0.5, blue: 0.25)] }
        if t.contains("chinese") { return [Color(red: 0.85, green: 0.2, blue: 0.2), Color(red: 0.65, green: 0.1, blue: 0.1)] }
        if t.contains("mughlai") { return [Color(red: 0.55, green: 0.3, blue: 0.8), Color(red: 0.4, green: 0.15, blue: 0.65)] }
        if t.contains("parsi") { return [Color(red: 0.2, green: 0.65, blue: 0.65), Color(red: 0.1, green: 0.45, blue: 0.5)] }
        if t.contains("north indian") { return [Color(red: 0.8, green: 0.35, blue: 0.1), Color(red: 0.6, green: 0.2, blue: 0.05)] }
        return [Color.savoryOrange, Color(red: 0.8, green: 0.28, blue: 0.04)]
    }

    private func loadCoverImage() async {
        guard coverImageUrl == nil else { return }
        if let items = try? await APIService.fetchMenu(restaurantID: restaurant.restaurantID),
           let first = items.first(where: { $0.imageUrl != nil }) {
            coverImageUrl = first.imageUrl
        }
    }
}
