//
//  RestaurantDetailViewModel.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

@Observable
class RestaurantDetailViewModel {
    var menuItems: [MenuItem] = []
    var isLoading = false
    var menuSearch = ""
    var selectedCategory = "Recommended"

    private let categoryKeywordsMap: [String: [String]] = [
        "Biryani": ["biryani"],
        "Starters": ["tikka", " 65", "kebab", "fried", "fry", "pakora", "chaat", "chilli", "popcorn"],
        "Main Course": ["curry", "masala", "gravy", "korma", "dal", "paneer", "butter", "haleem", "kofta", "gosht", "saag"],
        "Rice & Breads": ["rice", "naan", "roti", "paratha", "pulao", "jeera"],
        "Desserts": ["halwa", "kheer", "gulab", "ice cream", "sheer", "falooda", "payasam", "phirni", "kulfi"]
    ]

    var categories: [String] {
        var cats: [String] = ["Recommended"]
        let allNames = menuItems.map { $0.itemName.lowercased() }
        let order = ["Biryani", "Starters", "Main Course", "Rice & Breads", "Desserts"]
        for cat in order {
            let keywords = categoryKeywordsMap[cat] ?? []
            if allNames.contains(where: { name in keywords.contains(where: { name.contains($0) }) }) {
                cats.append(cat)
            }
        }
        return cats
    }

    var filteredItems: [MenuItem] {
        var items = menuItems

        if !menuSearch.isEmpty {
            items = items.filter {
                $0.itemName.localizedCaseInsensitiveContains(menuSearch) ||
                $0.itemDescription.localizedCaseInsensitiveContains(menuSearch)
            }
        }

        if selectedCategory != "Recommended" {
            let keywords = categoryKeywordsMap[selectedCategory] ?? []
            if !keywords.isEmpty {
                items = items.filter { item in
                    let name = item.itemName.lowercased()
                    return keywords.contains(where: { name.contains($0) })
                }
            }
        }

        return items
    }

    func load(restaurantID: Int) async {
        guard menuItems.isEmpty else { return }
        isLoading = true
        menuItems = (try? await APIService.fetchMenu(restaurantID: restaurantID)) ?? []
        isLoading = false
    }
}
