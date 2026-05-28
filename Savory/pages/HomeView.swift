//
//  HomeView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HomeHeaderView()
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Good morning,")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                    Text("Hungry today?")
                        .font(.savoryTitle())
                        .foregroundStyle(.primary)
                }
                .padding(.top, 18)

                SearchBarView(text: $searchText)
                    .padding(.top, 16)

                CategoryChipsView(selected: $selectedCategory)
                    .padding(.top, 24)

                if viewModel.isLoading {
                    HomeSkeleton()
                        .padding(.top, 24)
                } else {
                    if !viewModel.popularRestaurants.isEmpty {
                        PopularRestaurantsSectionView(
                            restaurants: viewModel.popularRestaurants,
                            title: "Popular Restaurants"
                        )
                        .padding(.top, 28)
                    }

                    PromoBannerView()
                        .padding(.top, 24)

                    if !viewModel.recommendedRestaurants.isEmpty {
                        PopularRestaurantsSectionView(
                            restaurants: viewModel.recommendedRestaurants,
                            title: "Recommended for you"
                        )
                        .padding(.top, 28)
                    }
                }

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAll()
        }
    }
}

#Preview {
    HomeView()
}
