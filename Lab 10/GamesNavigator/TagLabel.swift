//
//  TagLabel.swift
//  GamesNavigator
//

import UIKit

/// Small rounded "genre tag" pill, like the tags on a store page.
final class TagLabel: UILabel {

    private let insets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)

    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        font = .systemFont(ofSize: 12, weight: .medium)
        textColor = UIColor(named: "BrandColor")
        backgroundColor = UIColor(named: "TagBackground")
        layer.cornerRadius = 3
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}

extension UIStackView {
    func setTags(_ tags: [String]) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        tags.forEach { addArrangedSubview(TagLabel(text: $0)) }
    }
}
