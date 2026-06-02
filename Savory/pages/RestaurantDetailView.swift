import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var viewModel = RestaurantDetailViewModel()
    @State private var isFavorite = false
    @State private var coverImageUrl: String?
    @State private var showCart = false
    @Environment(\.dismiss) private var dismiss
    @Environment(CartManager.self) private var cart

    private let photoHeight: CGFloat = 290
    private let cardOffset: CGFloat = 250

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground).ignoresSafeArea()
            scrollContent
            navButtons
            cartFloatingBar
        }
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.load(restaurantID: restaurant.restaurantID)
            coverImageUrl = viewModel.menuItems.first(where: { $0.imageUrl != nil })?.imageUrl
        }
        .sheet(isPresented: $showCart) {
            CartView()
                .environment(cart)
        }
    }

    // MARK: - Scroll layer

    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                photoLayer
                cardLayer
            }
            .frame(maxWidth: .infinity)
        }
        .coordinateSpace(name: "detailScroll")
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Hero image with parallax

    private var photoLayer: some View {
        GeometryReader { geo in
            let scrollY = geo.frame(in: .named("detailScroll")).minY
            let isRubberBand = scrollY > 0
            let frameH = isRubberBand ? photoHeight + scrollY : photoHeight
            let offsetY = isRubberBand ? -scrollY : -scrollY * 0.5

            Group {
                if let urlStr = coverImageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        default:
                            cuisineGradient
                        }
                    }
                } else {
                    cuisineGradient
                }
            }
            .frame(width: geo.size.width, height: max(frameH, photoHeight))
            .clipped()
            .offset(y: offsetY)
        }
        .frame(height: photoHeight)
    }

    private var cuisineGradient: some View {
        LinearGradient(
            colors: cuisineGradientColors(for: restaurant.type),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Card layer

    private var cardLayer: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: cardOffset).allowsHitTesting(false)
            infoCard
            Color(.systemBackground).frame(height: 80)
        }
    }

    // MARK: - White info card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            restaurantHeader
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

            Divider().padding(.horizontal, 20)

            menuSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(TopRoundedShape(radius: 26))
    }

    // MARK: - Restaurant header

    private var restaurantHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: cuisineGradientColors(for: restaurant.type),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                    Text(String(restaurant.restaurantName.prefix(2)).uppercased())
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(restaurant.restaurantName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(restaurant.type)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.white)
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.savoryOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                        Text(restaurant.deliveryTime)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)

                        Text("•")
                            .foregroundStyle(.secondary)

                        Text(restaurant.priceRange)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundStyle(.savoryOrange)
                Text(restaurant.address)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }

    // MARK: - Menu section

    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Text("Menu")
                    .font(.savorySectionTitle())
                    .foregroundStyle(.primary)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    TextField("Search in menu", text: $viewModel.menuSearch)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            if !viewModel.categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { cat in
                            categoryChip(cat)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 8)
            }

            if viewModel.isLoading {
                MenuSkeleton()
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            } else if viewModel.filteredItems.isEmpty {
                emptyMenuView
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredItems) { item in
                        MenuItemRow(item: item)
                        if item.id != viewModel.filteredItems.last?.id {
                            Divider().padding(.leading, 104)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }

    private func categoryChip(_ name: String) -> some View {
        let isSelected = viewModel.selectedCategory == name
        return Button {
            viewModel.selectedCategory = name
        } label: {
            HStack(spacing: 5) {
                if name == "Recommended" {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 11))
                }
                Text(name)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(isSelected ? .savoryOrange : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.savoryOrangeSoft : Color(.systemBackground))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isSelected ? Color.savoryOrange : Color(.systemGray4), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var emptyMenuView: some View {
        VStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .font(.system(size: 36))
                .foregroundStyle(.savoryOrange.opacity(0.35))
            Text("No items found")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    // MARK: - Floating nav buttons

    private var navButtons: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            Spacer()
            HStack(spacing: 10) {
                Button { isFavorite.toggle() } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(isFavorite ? .red : .white)
                        .frame(width: 38, height: 38)
                        .background(isFavorite ? Color.white : Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 68)
    }

    // MARK: - Floating cart bar

    @ViewBuilder
    private var cartFloatingBar: some View {
        if cart.totalItems > 0 {
            VStack {
                Spacer()
                Button { showCart = true } label: {
                    HStack {
                        Text("\(cart.totalItems) item\(cart.totalItems == 1 ? "" : "s") added")
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                        Text("View Cart →")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 54)
                    .background(Color.savoryOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .savoryOrange.opacity(0.4), radius: 12, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
    }
}

// MARK: - Menu item row

struct MenuItemRow: View {
    let item: MenuItem
    @Environment(CartManager.self) private var cart

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.imageUrl.flatMap(URL.init)) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Color(.systemGray5)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(item.itemDescription)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("₹\(Int(item.itemPrice))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.savoryOrange)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button { cart.add(item) } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.savoryOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 14)
    }
}

// MARK: - Top-only rounded shape

private struct TopRoundedShape: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        p.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + radius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
