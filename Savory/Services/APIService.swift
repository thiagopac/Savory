//
//  APIService.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

enum APIService {
    static let baseURL = "https://fakerestaurantapi.runasp.net/api"

    static func fetchRestaurants() async throws -> [Restaurant] {
        guard let url = URL(string: "\(baseURL)/Restaurant") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Restaurant].self, from: data)
    }

    static func fetchRestaurantsByCategory(_ category: String) async throws -> [Restaurant] {
        let encoded = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        guard let url = URL(string: "\(baseURL)/Restaurant?category=\(encoded)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Restaurant].self, from: data)
    }

    static func fetchMenu(restaurantID: Int) async throws -> [MenuItem] {
        guard let url = URL(string: "\(baseURL)/Restaurant/\(restaurantID)/menu") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([MenuItem].self, from: data)
    }

    static func searchRestaurants(name: String) async throws -> [Restaurant] {
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        guard let url = URL(string: "\(baseURL)/Restaurant?name=\(encoded)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Restaurant].self, from: data)
    }

    static func searchItems(name: String) async throws -> [MenuItem] {
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        guard let url = URL(string: "\(baseURL)/Restaurant/items?ItemName=\(encoded)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([MenuItem].self, from: data)
    }
}
