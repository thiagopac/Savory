//
//  Theme.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

extension Color {
    static let savoryOrange = Color(red: 0.976, green: 0.416, blue: 0.067)
    static let savoryOrangeSoft = Color(red: 1.0, green: 0.945, blue: 0.878)
    static let savoryCard = Color(.systemBackground)
    static let savorySubtext = Color(.secondaryLabel)
}

extension ShapeStyle where Self == Color {
    static var savoryOrange: Color { Color(red: 0.976, green: 0.416, blue: 0.067) }
    static var savoryOrangeSoft: Color { Color(red: 1.0, green: 0.945, blue: 0.878) }
}

extension Font {
    static func savoryTitle() -> Font { .system(size: 26, weight: .bold) }
    static func savorySectionTitle() -> Font { .system(size: 18, weight: .bold) }
}

func cuisineGradientColors(for type: String) -> [Color] {
    let t = type.lowercased()
    if t.contains("biryani")      { return [Color(red: 0.90, green: 0.60, blue: 0.15), Color(red: 0.75, green: 0.40, blue: 0.08)] }
    if t.contains("south indian") { return [Color(red: 0.20, green: 0.70, blue: 0.40), Color(red: 0.10, green: 0.50, blue: 0.25)] }
    if t.contains("chinese")      { return [Color(red: 0.85, green: 0.20, blue: 0.20), Color(red: 0.65, green: 0.10, blue: 0.10)] }
    if t.contains("mughlai")      { return [Color(red: 0.55, green: 0.30, blue: 0.80), Color(red: 0.40, green: 0.15, blue: 0.65)] }
    if t.contains("parsi")        { return [Color(red: 0.20, green: 0.65, blue: 0.65), Color(red: 0.10, green: 0.45, blue: 0.50)] }
    if t.contains("north indian") { return [Color(red: 0.80, green: 0.35, blue: 0.10), Color(red: 0.60, green: 0.20, blue: 0.05)] }
    return [Color.savoryOrange, Color(red: 0.80, green: 0.28, blue: 0.04)]
}
