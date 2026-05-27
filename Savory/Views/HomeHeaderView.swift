import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Button {
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.savoryOrange)
                    Text("Hyderabad, TS")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(8)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Circle())
            }
        }
    }
}
