//
//  OrderItem.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

struct OrderItem: Codable, Identifiable {
    let orderID: Int
    let userID: String
    let itemName: String
    let quantity: Int
    let itemPrice: Double
    let totalPrice: Double
    let masterID: Int

    var id: Int { orderID }
}
