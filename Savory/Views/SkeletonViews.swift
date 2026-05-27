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
