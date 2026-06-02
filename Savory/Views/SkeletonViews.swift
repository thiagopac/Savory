//
//  SkeletonViews.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct SkeletonBlock: View {
    var cornerRadius: CGFloat = 8
    @State private var opacity: Double = 0.1

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(.systemFill))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    opacity = 0.4
                }
            }
    }
}

struct SearchSkeleton: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SkeletonBlock(cornerRadius: 6).frame(width: 130, height: 18)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                ForEach(0..<6, id: \.self) { _ in
                    HStack(spacing: 14) {
                        SkeletonBlock(cornerRadius: 12).frame(width: 72, height: 72)
                        VStack(alignment: .leading, spacing: 7) {
                            SkeletonBlock(cornerRadius: 4).frame(width: 140, height: 14)
                            SkeletonBlock(cornerRadius: 4).frame(width: 100, height: 11)
                            SkeletonBlock(cornerRadius: 4).frame(width: 80, height: 11)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)

                    if true {
                        Divider().padding(.leading, 102)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct MenuSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonBlock(cornerRadius: 12).frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 7) {
                        SkeletonBlock(cornerRadius: 4).frame(width: 140, height: 14)
                        SkeletonBlock(cornerRadius: 4).frame(width: 200, height: 11)
                        SkeletonBlock(cornerRadius: 4).frame(width: 160, height: 11)
                        SkeletonBlock(cornerRadius: 4).frame(width: 60, height: 13)
                    }
                    Spacer()
                    SkeletonBlock(cornerRadius: 10).frame(width: 38, height: 38)
                }
                .padding(.vertical, 14)
                Divider().padding(.leading, 92)
            }
        }
    }
}

struct HomeSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 14) {
                ForEach(0..<5, id: \.self) { _ in
                    VStack(spacing: 6) {
                        SkeletonBlock(cornerRadius: 28).frame(width: 56, height: 56)
                        SkeletonBlock(cornerRadius: 4).frame(width: 48, height: 10)
                    }
                }
            }
            .padding(.top, 4)

            HStack {
                SkeletonBlock(cornerRadius: 6).frame(width: 170, height: 20)
                Spacer()
                SkeletonBlock(cornerRadius: 6).frame(width: 50, height: 14)
            }
            .padding(.top, 32)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBlock(cornerRadius: 14).frame(width: 180, height: 195)
                    }
                }
            }
            .disabled(true)
            .padding(.top, 14)

            SkeletonBlock(cornerRadius: 18).frame(height: 100).padding(.top, 24)

            HStack {
                SkeletonBlock(cornerRadius: 6).frame(width: 170, height: 20)
                Spacer()
                SkeletonBlock(cornerRadius: 6).frame(width: 50, height: 14)
            }
            .padding(.top, 32)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBlock(cornerRadius: 14).frame(width: 180, height: 195)
                    }
                }
            }
            .disabled(true)
            .padding(.top, 14)
        }
    }
}
