//
//  FavoriteCell.swift
//  FavoriteGames
//
//  Created by Alikhan on 05.11.2026.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    func configure(with item: FavoriteItem) {
        coverImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
        }
    }

}
