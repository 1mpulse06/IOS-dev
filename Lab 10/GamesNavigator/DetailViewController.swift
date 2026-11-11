//
//  DetailViewController.swift
//  GamesNavigator
//
//  Created by Alikhan on 12.11.2026.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var steamButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    var item: FavoriteItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        gradientView.colors = [.clear, UIColor(named: "AppBackground") ?? .black]
        setupSteamButton()

        guard let item = item else { return }
        title = item.title
        coverImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle.uppercased()
        descriptionLabel.text = item.description
        tagsStackView.setTags(item.tags)

        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
        }
    }

    private func setupSteamButton() {
        var config = UIButton.Configuration.filled()
        config.title = "View on Steam"
        config.image = UIImage(systemName: "arrow.up.right.square")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(named: "ButtonGreen")
        config.baseForegroundColor = .white
        config.cornerStyle = .small
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var attrs = attrs
            attrs.font = .systemFont(ofSize: 17, weight: .semibold)
            return attrs
        }
        steamButton.configuration = config
    }

    @IBAction func steamButtonTapped(_ sender: UIButton) {
        guard let url = item?.steamURL else { return }
        UIApplication.shared.open(url)
    }

}

/// View that draws a vertical gradient (used to fade the cover into the background).
final class GradientView: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }

    var colors: [UIColor] = [] {
        didSet { (layer as? CAGradientLayer)?.colors = colors.map { $0.cgColor } }
    }
}
