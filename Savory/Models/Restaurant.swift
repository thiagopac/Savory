//
//  Restaurant.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

struct Restaurant: Codable, Identifiable, Hashable {
    let restaurantID: Int
    let restaurantName: String
    let address: String
    let type: String
    let parkingLot: Bool

    var id: Int { restaurantID }

    var rating: Double {
        let val = 3.6 + Double(restaurantID % 14) * 0.1
        return min(5.0, val)
    }

    var deliveryTime: String { "30-40 min" }
    var priceRange: String { "$$" }

    var initials: String {
        let words = restaurantName.split(separator: " ").prefix(2)
        return words.compactMap { $0.first.map { String($0) } }.joined().uppercased()
    }

    var cityName: String {
        address.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? address
    }

    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool { lhs.restaurantID == rhs.restaurantID }
    func hash(into hasher: inout Hasher) { hasher.combine(restaurantID) }
}
