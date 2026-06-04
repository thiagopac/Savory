//
//  FavoritesManager.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

@Observable
class FavoritesManager {
    var favorites: [Restaurant] = []

    func toggle(_ restaurant: Restaurant) {
        if isFavorite(restaurant) {
            favorites.removeAll { $0.restaurantID == restaurant.restaurantID }
        } else {
            favorites.append(restaurant)
        }
    }

    func isFavorite(_ restaurant: Restaurant) -> Bool {
        favorites.contains { $0.restaurantID == restaurant.restaurantID }
    }
}
