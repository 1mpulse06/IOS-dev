//
//  FavoriteCell.swift
//  GamesNavigator
//
//  Created by Alikhan on 12.11.2026.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        cardView.layer.cornerRadius = 6
        cardView.clipsToBounds = true
    }

    func configure(with item: FavoriteItem) {
        coverImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        ratingLabel.text = String(repeating: "★", count: item.rating)
            + String(repeating: "☆", count: 5 - item.rating)
        tagsStackView.setTags(item.tags)
    }

    // Card gently shrinks while pressed
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: highlighted ? 0.1 : 0.25,
                       delay: 0,
                       options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.cardView.alpha = highlighted ? 0.85 : 1
        }
    }

}
