//
//  FavoriteItem.swift
//  GamesNavigator
//
//  Created by Alikhan on 12.11.2026.
//

import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
    let steamAppID: Int
    let tags: [String]
    let description: String

    var steamURL: URL? {
        URL(string: "https://store.steampowered.com/app/\(steamAppID)")
    }
}
