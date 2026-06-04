//
//  OrdersView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct OrdersView: View {
    @State private var viewModel = OrdersViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ScrollView(showsIndicators: false) {
                    OrdersSkeleton()
                        .padding(.top, 8)
                }
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if viewModel.orders.isEmpty {
                emptyView
            } else {
                ordersList
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.reload() }
    }

    private var ordersList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.orders) { order in
                    NavigationLink {
                        OrderDetailView(
                            order: order,
                            restaurant: viewModel.restaurant(for: order)
                        )
                    } label: {
                        OrderCard(order: order, restaurant: viewModel.restaurant(for: order))
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await viewModel.delete(masterID: order.masterID) }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "list.clipboard")
                .font(.system(size: 56))
                .foregroundStyle(.savoryOrange.opacity(0.3))
            Text("No orders yet")
                .font(.system(size: 17, weight: .semibold))
            Text("Your order history will appear here")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(.savoryOrange.opacity(0.4))
            Text("Couldn't load orders")
                .font(.system(size: 17, weight: .semibold))
            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Try Again") {
                Task { await viewModel.reload() }
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.savoryOrange)
            .clipShape(Capsule())
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Order card

struct OrderCard: View {
    let order: MasterOrder
    let restaurant: Restaurant?

    var body: some View {
        HStack(spacing: 14) {
            avatarCircle

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text("Order #\(order.masterID)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                    deliveredBadge
                }
                Text(restaurant?.restaurantName ?? "Restaurant #\(order.restaurantID)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(restaurant?.type ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.tertiaryLabel))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Text(priceUSD(order.grandtotal))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private var avatarCircle: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: cuisineGradientColors(for: restaurant?.type ?? ""),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 52, height: 52)
            Text(restaurant?.initials ?? "#")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
        }
    }

    private var deliveredBadge: some View {
        Text("Delivered")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.green)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.green.opacity(0.12))
            .clipShape(Capsule())
    }
}
