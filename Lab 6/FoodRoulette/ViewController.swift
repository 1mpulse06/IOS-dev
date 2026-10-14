//
//  ViewController.swift
//  FoodRoulette
//
//  Created by Alikhan on 15.10.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    let favorites = [
        Favorite(title: "Beshbarmak", description: "Boiled meat with flat noodles and onion sauce. The main dish at every big family dinner.", imageName: "beshbarmak"),
        Favorite(title: "Plov", description: "Rice cooked with lamb, carrots and garlic in a big kazan. Best when it is made outside.", imageName: "plov"),
        Favorite(title: "Baursak", description: "Small pieces of fried dough, soft inside. Perfect with tea and honey.", imageName: "baursak"),
        Favorite(title: "Lagman", description: "Hand-pulled noodles with beef and vegetables in a spicy sauce.", imageName: "lagman"),
        Favorite(title: "Manti", description: "Big steamed dumplings with meat and pumpkin. I always eat them with sour cream.", imageName: "manti"),
        Favorite(title: "Ramen", description: "Japanese noodle soup with egg, pork and green onion. Great on a cold day.", imageName: "ramen"),
        Favorite(title: "Pizza Margherita", description: "Thin crust, tomato sauce, mozzarella and basil. Simple but always good.", imageName: "margherita"),
        Favorite(title: "Sushi", description: "Rice rolls with salmon and avocado. My usual order on Friday evenings.", imageName: "sushi"),
        Favorite(title: "Shawarma", description: "Chicken, vegetables and garlic sauce wrapped in pita. The best quick lunch after classes.", imageName: "shawarma"),
        Favorite(title: "Cheesecake", description: "Creamy dessert with a crunchy biscuit base and berry topping.", imageName: "cheesecake")
    ]

    var currentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func spinButtonTapped(_ sender: UIButton) {
        var newIndex = Int.random(in: 0..<favorites.count)
        while newIndex == currentIndex {
            newIndex = Int.random(in: 0..<favorites.count)
        }
        currentIndex = newIndex

        let food = favorites[newIndex]
        foodImageView.image = UIImage(named: food.imageName)
        titleLabel.text = food.title
        descriptionLabel.text = food.description
    }

}
