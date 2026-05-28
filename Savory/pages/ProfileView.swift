//
//  ProfileView.swift
//  Savory
//
//  Created by Thiago Castro on 08/06/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.savoryOrangeSoft)
                            .frame(width: 88, height: 88)
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.savoryOrange)
                    }

                    Text("Guest User")
                        .font(.system(size: 20, weight: .bold))

                    Text("Sign in to manage your account")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)

                    Button {
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.savoryOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                }
                .padding(.top, 32)
                .padding(.bottom, 32)

                Divider()

                Group {
                    ProfileRowView(icon: "mappin.and.ellipse", title: "Saved Addresses")
                    Divider().padding(.leading, 52)
                    ProfileRowView(icon: "creditcard", title: "Payment Methods")
                    Divider().padding(.leading, 52)
                    ProfileRowView(icon: "bell", title: "Notifications")
                    Divider().padding(.leading, 52)
                    ProfileRowView(icon: "questionmark.circle", title: "Help & Support")
                    Divider().padding(.leading, 52)
                    ProfileRowView(icon: "info.circle", title: "About")
                }
                .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileRowView: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.savoryOrange)
                .frame(width: 36)

            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
    }
}
