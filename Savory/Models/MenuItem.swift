//
//  MenuItem.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

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
