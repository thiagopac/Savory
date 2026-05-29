//
//  SearchViewModel.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

@Observable
class SearchViewModel {
    var restaurants: [Restaurant] = []
    var dishes: [MenuItem] = []
    var isLoading = false

    private var searchTask: Task<Void, Never>?

    var hasResults: Bool { !restaurants.isEmpty || !dishes.isEmpty }

    func search(query: String) {
        searchTask?.cancel()
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else {
            restaurants = []
            dishes = []
            isLoading = false
            return
        }
        isLoading = true
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            async let rests = APIService.searchRestaurants(name: q)
            async let items = APIService.searchItems(name: q)
            let r = (try? await rests) ?? []
            let d = (try? await items) ?? []
            guard !Task.isCancelled else { return }
            restaurants = r
            dishes = d
            isLoading = false
        }
    }

    func filterByCategory(_ category: String) {
        searchTask?.cancel()
        isLoading = true
        dishes = []
        searchTask = Task {
            restaurants = (try? await APIService.fetchRestaurantsByCategory(category)) ?? []
            isLoading = false
        }
    }
}
