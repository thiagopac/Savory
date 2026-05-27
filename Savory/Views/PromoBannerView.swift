import SwiftUI

struct PromoBannerView: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Flat 20% OFF")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.primary)
                    Text("On your first order")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Button {
                } label: {
                    Text("ORDER NOW")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(.savoryOrange)
                        .clipShape(Capsule())
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 20)

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.savoryOrange.opacity(0.15))
                    .frame(width: 90, height: 90)
                Image(systemName: "bicycle")
                    .font(.system(size: 36))
                    .foregroundStyle(.savoryOrange)
            }
            .padding(.trailing, 20)
        }
        .background(Color.savoryOrangeSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
