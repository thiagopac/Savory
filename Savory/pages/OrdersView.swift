import SwiftUI

struct OrdersView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "list.clipboard")
                .font(.system(size: 56))
                .foregroundStyle(.savoryOrange.opacity(0.3))

            Text("No orders yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)

            Text("Your order history will appear here")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.large)
    }
}
