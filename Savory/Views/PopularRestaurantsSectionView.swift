import SwiftUI

struct PopularRestaurantsSectionView: View {
    let restaurants: [Restaurant]
    let title: String
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.savorySectionTitle())
                    .foregroundStyle(.primary)
                Spacer()
                Button("See all") { onSeeAll?() }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.savoryOrange)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(restaurants) { restaurant in
                        RestaurantCardView(restaurant: restaurant)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
            .padding(.horizontal, -16)
        }
    }
}
