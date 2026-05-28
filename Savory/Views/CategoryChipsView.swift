//
//  CategoryChipsView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

let homeCategoryItems: [CategoryItem] = [
    CategoryItem(name: "Biryani", icon: "flame.fill", color: Color(red: 0.9, green: 0.55, blue: 0.1)),
    CategoryItem(name: "Parsi Cuisine", icon: "crown.fill", color: Color(red: 0.2, green: 0.65, blue: 0.6)),
    CategoryItem(name: "South Indian", icon: "leaf.fill", color: Color(red: 0.25, green: 0.65, blue: 0.35)),
    CategoryItem(name: "Chinese", icon: "fork.knife", color: Color(red: 0.85, green: 0.2, blue: 0.2)),
    CategoryItem(name: "Desserts", icon: "heart.fill", color: Color(red: 0.9, green: 0.35, blue: 0.55)),
    CategoryItem(name: "North Indian", icon: "star.fill", color: Color(red: 0.55, green: 0.3, blue: 0.8)),
]

struct CategoryChipsView: View {
    @Binding var selected: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(homeCategoryItems) { item in
                    CategoryChipItem(item: item, isSelected: selected == item.name) {
                        selected = selected == item.name ? nil : item.name
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
        .padding(.horizontal, -16)
    }
}

struct CategoryChipItem: View {
    let item: CategoryItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? item.color : item.color.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: item.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(isSelected ? .white : item.color)
                }
                Text(item.name)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(isSelected ? .savoryOrange : .primary)
                    .lineLimit(1)
                    .fixedSize()
            }
            .frame(width: 64)
        }
        .buttonStyle(.plain)
    }
}
