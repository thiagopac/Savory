//
//  MainTabView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var cartManager = CartManager()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                SearchView()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            NavigationStack {
                OrdersView()
            }
            .tabItem { Label("Orders", systemImage: "list.clipboard.fill") }

            NavigationStack {
                FavoritesView()
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.savoryOrange)
        .environment(cartManager)
    }
}
