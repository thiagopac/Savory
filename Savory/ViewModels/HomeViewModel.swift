//
//  HomeViewModel.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

@Observable
class HomeViewModel {
    var restaurants: [Restaurant] = []
    var isLoading = false

    var popularRestaurants: [Restaurant] { Array(restaurants.prefix(8)) }
    var recommendedRestaurants: [Restaurant] { Array(restaurants.dropFirst(4).prefix(8)) }

    func loadAll() async {
        guard restaurants.isEmpty else { return }
        isLoading = true
        restaurants = (try? await APIService.fetchRestaurants()) ?? []
        isLoading = false
    }
}
