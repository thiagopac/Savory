import Foundation

struct CartItem: Identifiable {
    let item: MenuItem
    var quantity: Int
    var id: Int { item.itemID }
}

@Observable
class CartManager {
    var cartItems: [CartItem] = []

    var totalItems: Int { cartItems.reduce(0) { $0 + $1.quantity } }
    var subtotal: Double { cartItems.reduce(0) { $0 + $1.item.itemPrice * Double($1.quantity) } }
    var discount: Double { subtotal * 0.2 }
    var deliveryFee: Double { 30 }
    var total: Double { subtotal - discount + deliveryFee }

    func add(_ item: MenuItem) {
        if let idx = cartItems.firstIndex(where: { $0.item.itemID == item.itemID }) {
            cartItems[idx].quantity += 1
        } else {
            cartItems.append(CartItem(item: item, quantity: 1))
        }
    }

    func remove(_ item: MenuItem) {
        guard let idx = cartItems.firstIndex(where: { $0.item.itemID == item.itemID }) else { return }
        if cartItems[idx].quantity > 1 {
            cartItems[idx].quantity -= 1
        } else {
            cartItems.remove(at: idx)
        }
    }

    func delete(_ item: MenuItem) {
        cartItems.removeAll { $0.item.itemID == item.itemID }
    }

    func quantity(for item: MenuItem) -> Int {
        cartItems.first(where: { $0.item.itemID == item.itemID })?.quantity ?? 0
    }
}
