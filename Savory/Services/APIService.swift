//
//  APIService.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

private struct PlaceOrderBody: Encodable {
    struct MenuOrderItem: Encodable {
        let itemName: String
        let quantity: Int
    }
    let menuDTO: [MenuOrderItem]
}

enum APIService {
    static let baseURL = "https://fakerestaurantapi.runasp.net/api"
    static let testAPIKey = "cbc4ecf6-7eda-47e7-bbae-de84be9c796c"

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

    static func fetchOrders() async throws -> [MasterOrder] {
        guard let url = URL(string: "\(baseURL)/Order?apikey=\(testAPIKey)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([MasterOrder].self, from: data)
    }

    static func fetchOrderItems(masterID: Int) async throws -> [OrderItem] {
        guard let url = URL(string: "\(baseURL)/Order/\(masterID)?apikey=\(testAPIKey)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([OrderItem].self, from: data)
    }

    static func deleteMasterOrder(masterID: Int) async throws {
        guard let url = URL(string: "\(baseURL)/Order/master/\(masterID)?apikey=\(testAPIKey)") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: request)
    }

    static func placeOrder(restaurantID: Int, items: [(itemName: String, quantity: Int)]) async throws {
        guard let url = URL(string: "\(baseURL)/Order/\(restaurantID)/makeorder?apikey=\(testAPIKey)") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PlaceOrderBody(menuDTO: items.map { .init(itemName: $0.itemName, quantity: $0.quantity) })
        request.httpBody = try JSONEncoder().encode(body)
        _ = try await URLSession.shared.data(for: request)
    }
}
