//
//  OrdersViewModel.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import Foundation

@Observable
class OrdersViewModel {
    var orders: [MasterOrder] = []
    var restaurantMap: [Int: Restaurant] = [:]
    var isLoading = false
    var errorMessage: String? = nil

    func load() async {
        guard orders.isEmpty else { return }
        await reload()
    }

    func reload() async {
        isLoading = true
        errorMessage = nil
        async let ordersTask = APIService.fetchOrders()
        async let restaurantsTask = APIService.fetchRestaurants()
        do {
            let (fetched, restaurants) = try await (ordersTask, restaurantsTask)
            orders = fetched.sorted { $0.masterID > $1.masterID }
            restaurantMap = Dictionary(uniqueKeysWithValues: restaurants.map { ($0.restaurantID, $0) })
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func restaurant(for order: MasterOrder) -> Restaurant? {
        restaurantMap[order.restaurantID]
    }

    func delete(masterID: Int) async {
        orders.removeAll { $0.masterID == masterID }
        try? await APIService.deleteMasterOrder(masterID: masterID)
    }
}
