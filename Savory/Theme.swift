//
//  Theme.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//


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
