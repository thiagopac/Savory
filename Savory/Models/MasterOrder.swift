//
//  MasterOrder.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

struct MasterOrder: Codable, Identifiable {
    let masterID: Int
    let userID: String
    let usercode: String
    let restaurantID: Int
    let grandtotal: Double

    var id: Int { masterID }
}
