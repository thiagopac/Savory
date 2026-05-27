import Foundation

struct MenuItem: Codable, Identifiable {
    let itemID: Int
    let itemName: String
    let itemDescription: String
    let itemPrice: Double
    let restaurantName: String
    let restaurantID: Int
    let imageUrl: String?

    var id: Int { itemID }
}
