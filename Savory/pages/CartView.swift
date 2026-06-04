//
//  CartView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct CartView: View {
    @Environment(CartManager.self) private var cart
    @Environment(\.dismiss) private var dismiss
    @State private var isPlacingOrder = false
    @State private var orderSuccess = false
    @State private var orderError: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if orderSuccess {
                    orderSuccessView
                } else if cart.cartItems.isEmpty {
                    emptyCart
                } else {
                    ZStack(alignment: .bottom) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                itemsList
                                savingsBanner
                                priceSummary
                            }
                            .padding(.bottom, 110)
                        }
                        checkoutButton
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if cart.totalItems > 0 {
                        Text("\(cart.totalItems) item\(cart.totalItems == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.savoryOrange)
                    }
                }
            }
        }
    }

    private var emptyCart: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 52))
                .foregroundStyle(.savoryOrange.opacity(0.35))
            Text("Your cart is empty")
                .font(.system(size: 18, weight: .semibold))
            Text("Add items from a restaurant to start an order")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
    }

    private var itemsList: some View {
        VStack(spacing: 0) {
            ForEach(cart.cartItems) { cartItem in
                CartItemRow(cartItem: cartItem)
                if cartItem.id != cart.cartItems.last?.id {
                    Divider().padding(.leading, 98)
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private var savingsBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "tag.fill")
                .font(.system(size: 18))
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("You're saving \(priceUSD(cart.discount))!")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.green)
                Text("Flat 20% OFF applied")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Remove") {}
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.savoryOrange)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var priceSummary: some View {
        VStack(spacing: 14) {
            summaryRow("Subtotal", value: priceUSD(cart.subtotal))
            summaryRow("Discount (20%)", value: "−\(priceUSD(cart.discount))", valueColor: .green)

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
                Text(priceUSD(cart.deliveryFee))
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack {
                Text("Total")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Text(priceUSD(cart.total))
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
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

    private var checkoutButton: some View {
        VStack(spacing: 0) {
            if let error = orderError {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
            Divider()
            Button {
                Task { await placeOrder() }
            } label: {
                Group {
                    if isPlacingOrder {
                        ProgressView()
                            .tint(.white)
                    } else {
                        HStack(spacing: 8) {
                            Text("Proceed to Checkout")
                                .font(.system(size: 17, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.savoryOrange)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(isPlacingOrder)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(Color(.systemGroupedBackground))
        }
    }

    private var orderSuccessView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)
            Text("Order Placed!")
                .font(.system(size: 24, weight: .bold))
            Text("Your order has been placed successfully.\nCheck the Orders tab to track it.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.savoryOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
            Spacer()
        }
    }

    private func placeOrder() async {
        guard let restaurantID = cart.cartItems.first?.item.restaurantID else { return }
        isPlacingOrder = true
        orderError = nil
        let items = cart.cartItems.map { (itemName: $0.item.itemName, quantity: $0.quantity) }
        do {
            try await APIService.placeOrder(restaurantID: restaurantID, items: items)
            cart.cartItems.removeAll()
            orderSuccess = true
        } catch {
            orderError = "Couldn't place order. Please try again."
        }
        isPlacingOrder = false
    }
}

// MARK: - Cart item row

struct CartItemRow: View {
    let cartItem: CartItem
    @Environment(CartManager.self) private var cart

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: cartItem.item.imageUrl.flatMap(URL.init)) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Color(.systemGray5)
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text(cartItem.item.itemName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(priceUSD(cartItem.item.itemPrice))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.savoryOrange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                Button { cart.remove(cartItem.item) } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(width: 26, height: 26)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }

                Text("\(cartItem.quantity)")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(minWidth: 18)

                Button { cart.add(cartItem.item) } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(width: 26, height: 26)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }

                Button { cart.delete(cartItem.item) } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
                .padding(.leading, 4)
            }
        }
        .padding(16)
    }
}
