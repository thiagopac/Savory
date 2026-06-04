//
//  OrderDetailView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct OrderDetailView: View {
    let order: MasterOrder
    let restaurant: Restaurant?

    @State private var items: [OrderItem] = []
    @State private var isLoading = false
    @State private var showDeleteConfirm = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                restaurantHeader
                    .padding(.top, 8)

                if isLoading {
                    MenuSkeleton()
                        .padding(.horizontal, 16)
                } else if items.isEmpty {
                    emptyItems
                } else {
                    itemsCard
                    priceSummary
                }

                deleteButton
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Order #\(order.masterID)")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadItems() }
        .confirmationDialog(
            "Delete this order?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete Order", role: .destructive) {
                Task {
                    try? await APIService.deleteMasterOrder(masterID: order.masterID)
                    dismiss()
                }
            }
        }
    }

    // MARK: - Restaurant header card

    private var restaurantHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: cuisineGradientColors(for: restaurant?.type ?? ""),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                Text(restaurant?.initials ?? "#")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant?.restaurantName ?? "Restaurant #\(order.restaurantID)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
                Text(restaurant?.type ?? "")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    Text("Delivered")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                    if let address = restaurant?.cityName {
                        Text("·")
                            .foregroundStyle(Color(.tertiaryLabel))
                        Text(address)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Items list card

    private var itemsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Items")
                .font(.savorySectionTitle())
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

            ForEach(items) { item in
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text("\(item.quantity)×")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.savoryOrange)
                            .frame(width: 28, alignment: .leading)

                        Text(item.itemName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .trailing, spacing: 2) {
                            Text(priceUSD(item.totalPrice))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.primary)
                            Text(priceUSD(item.itemPrice) + " each")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)

                    if item.id != items.last?.id {
                        Divider().padding(.leading, 56)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Price summary

    private var priceSummary: some View {
        VStack(spacing: 14) {
            summaryRow("Subtotal", value: priceUSD(subtotal))
            summaryRow("Discount (20%)", value: "−\(priceUSD(subtotal * 0.2))", valueColor: .green)
            HStack {
                HStack(spacing: 4) {
                    Text("Delivery Fee")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                    Image(systemName: "info.circle")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(priceUSD(30))
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            Divider()
            HStack {
                Text("Total")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Text(priceUSD(order.grandtotal))
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func summaryRow(_ title: String, value: String, valueColor: Color = .secondary) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(valueColor)
        }
    }

    // MARK: - Delete button

    private var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .semibold))
                Text("Delete Order")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var emptyItems: some View {
        VStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .font(.system(size: 36))
                .foregroundStyle(.savoryOrange.opacity(0.35))
            Text("No items found")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Helpers

    private var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    private func loadItems() async {
        guard items.isEmpty else { return }
        isLoading = true
        items = (try? await APIService.fetchOrderItems(masterID: order.masterID)) ?? []
        isLoading = false
    }
}
