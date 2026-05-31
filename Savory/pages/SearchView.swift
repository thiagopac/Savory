//
//  SearchView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var query = ""

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(text: $query)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 12)

            Divider()

            Group {
                if query.isEmpty {
                    categoryBrowser
                } else if viewModel.isLoading {
                    SearchSkeleton()
                } else if !viewModel.hasResults {
                    emptyResults
                } else {
                    resultsView
                }
            }
            .animation(.easeInOut(duration: 0.18), value: query.isEmpty)
            .animation(.easeInOut(duration: 0.18), value: viewModel.isLoading)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: query) { _, new in viewModel.search(query: new) }
    }

    private var categoryBrowser: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Browse by Category")
                    .font(.savorySectionTitle())
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 12
                ) {
                    ForEach(homeCategoryItems) { item in
                        CategoryBrowseCard(item: item) {
                            query = item.name
                            viewModel.filterByCategory(item.name)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }

    private var resultsView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.restaurants.isEmpty {
                    resultSectionHeader("Restaurants", count: viewModel.restaurants.count)

                    ForEach(viewModel.restaurants) { restaurant in
                        RestaurantRowView(restaurant: restaurant)
                        if restaurant.id != viewModel.restaurants.last?.id {
                            Divider().padding(.leading, 102)
                        }
                    }
                }

                if !viewModel.dishes.isEmpty {
                    resultSectionHeader("Dishes", count: viewModel.dishes.count)
                        .padding(.top, viewModel.restaurants.isEmpty ? 0 : 12)

                    ForEach(viewModel.dishes) { dish in
                        DishRowView(dish: dish)
                        if dish.id != viewModel.dishes.last?.id {
                            Divider().padding(.leading, 102)
                        }
                    }
                }

                Spacer(minLength: 24)
            }
        }
        .background(Color(.systemBackground))
    }

    private var emptyResults: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 52))
                .foregroundStyle(.savoryOrange.opacity(0.35))
            Text("No results for \"\(query)\"")
                .font(.system(size: 16, weight: .semibold))
            Text("Try a different name or browse by category")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
    }

    private func resultSectionHeader(_ title: String, count: Int) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(title)
                .font(.savorySectionTitle())
            Text("(\(count))")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 4)
    }
}

struct CategoryBrowseCard: View {
    let item: CategoryItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(item.color)
                    .clipShape(Circle())

                Text(item.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Spacer()
            }
            .padding(12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
