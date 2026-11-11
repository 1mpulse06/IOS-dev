//
//  GameData.swift
//  GamesNavigator
//
//  Created by Alikhan on 12.11.2026.
//

import Foundation

struct GameData {
    static let items = [
        FavoriteItem(title: "Hollow Knight", subtitle: "Team Cherry · 2017", imageName: "hollow_knight", rating: 5,
                     steamAppID: 367520, tags: ["Metroidvania", "Souls-like", "2D"],
                     description: "A small knight explores a huge ruined underground kingdom full of bugs. The map is connected in clever ways and there is always a new secret behind the next wall. Some bosses took me more than an hour, but beating them felt amazing."),
        FavoriteItem(title: "Celeste", subtitle: "Maddy Makes Games · 2018", imageName: "celeste", rating: 5,
                     steamAppID: 504230, tags: ["Platformer", "Pixel Graphics", "Story Rich"],
                     description: "Madeline tries to climb a mountain while fighting her own anxiety. The platforming is hard but fair, and every death sends you back only a few seconds. The story and the soundtrack are honestly better than in many big games."),
        FavoriteItem(title: "Stardew Valley", subtitle: "ConcernedApe · 2016", imageName: "stardew_valley", rating: 4,
                     steamAppID: 413150, tags: ["Farming Sim", "Cozy", "Pixel Graphics"],
                     description: "You leave the city and move to your grandfather's old farm. Every day you plant crops, go fishing, explore the mines and make friends with the villagers. It is the most relaxing game I have ever played."),
        FavoriteItem(title: "Hades", subtitle: "Supergiant Games · 2020", imageName: "hades", rating: 5,
                     steamAppID: 1145360, tags: ["Roguelike", "Action", "Mythology"],
                     description: "Zagreus, the son of Hades, tries to escape from the underworld again and again. Each run gives you different powers from the Olympian gods. Even when you die the story moves forward, so it never feels like wasted time."),
        FavoriteItem(title: "The Witcher 3: Wild Hunt", subtitle: "CD Projekt Red · 2015", imageName: "witcher3", rating: 5,
                     steamAppID: 292030, tags: ["Open World", "RPG", "Fantasy"],
                     description: "Geralt searches for his adopted daughter Ciri in a huge dark fantasy world. Even small side quests have interesting stories and hard choices. The Blood and Wine expansion is a whole game by itself."),
        FavoriteItem(title: "Portal 2", subtitle: "Valve · 2011", imageName: "portal2", rating: 5,
                     steamAppID: 620, tags: ["Puzzle", "Co-op", "First-Person"],
                     description: "A puzzle game where you solve test chambers with a gun that creates portals. GLaDOS and Wheatley are some of the funniest characters in games. The co-op mode is perfect to play with a friend."),
        FavoriteItem(title: "Red Dead Redemption 2", subtitle: "Rockstar Games · 2018", imageName: "rdr2", rating: 4,
                     steamAppID: 1174180, tags: ["Open World", "Western", "Story Rich"],
                     description: "Arthur Morgan rides with a gang of outlaws at the end of the Wild West era. The world is incredibly detailed and feels alive. The story is slow at the start, but the ending is very emotional."),
        FavoriteItem(title: "Elden Ring", subtitle: "FromSoftware · 2022", imageName: "elden_ring", rating: 4,
                     steamAppID: 1245620, tags: ["Souls-like", "Open World", "RPG"],
                     description: "An open world action RPG from the creators of Dark Souls. You can go almost anywhere, and if a boss is too hard you can explore and come back stronger. Riding the horse across the Lands Between is beautiful."),
        FavoriteItem(title: "Terraria", subtitle: "Re-Logic · 2011", imageName: "terraria", rating: 3,
                     steamAppID: 105600, tags: ["Sandbox", "Survival", "2D"],
                     description: "A 2D sandbox game about digging, building and fighting bosses. It looks simple, but there are thousands of items to craft. It is much more fun when you play it together with friends."),
        FavoriteItem(title: "Undertale", subtitle: "Toby Fox · 2015", imageName: "undertale", rating: 4,
                     steamAppID: 391540, tags: ["RPG", "Story Rich", "Pixel Graphics"],
                     description: "A child falls into an underground world full of monsters. You can fight them or find a way to spare every single one. The game remembers your choices and the music is fantastic."),
        FavoriteItem(title: "Outer Wilds", subtitle: "Mobius Digital · 2019", imageName: "outer_wilds", rating: 5,
                     steamAppID: 753640, tags: ["Exploration", "Space", "Mystery"],
                     description: "You explore a small solar system that is stuck in a 22 minute time loop. There are no upgrades, only knowledge that you collect each loop. It is better to play it knowing as little as possible."),
        FavoriteItem(title: "Disco Elysium", subtitle: "ZA/UM · 2019", imageName: "disco_elysium", rating: 4,
                     steamAppID: 632470, tags: ["RPG", "Detective", "Story Rich"],
                     description: "A detective wakes up with amnesia and has to solve a murder case. There is no combat, everything is decided by dialogue and skill checks. The writing is strange, funny and smart at the same time."),
        FavoriteItem(title: "Cuphead", subtitle: "Studio MDHR · 2017", imageName: "cuphead", rating: 3,
                     steamAppID: 268910, tags: ["Bullet Hell", "Platformer", "Hand-drawn"],
                     description: "A run and gun game drawn in the style of 1930s cartoons. Almost the whole game is a series of very hard boss fights. It looks so good that I kept trying even after many deaths."),
        FavoriteItem(title: "Dead Cells", subtitle: "Motion Twin · 2018", imageName: "dead_cells", rating: 4,
                     steamAppID: 588650, tags: ["Roguelite", "Metroidvania", "Action"],
                     description: "A fast roguelike where you fight through a changing island castle. Combat feels smooth and there are many weapons to try. Each run is short, so it is good to play for half an hour."),
        FavoriteItem(title: "Inside", subtitle: "Playdead · 2016", imageName: "inside", rating: 3,
                     steamAppID: 304430, tags: ["Puzzle Platformer", "Atmospheric", "Dark"],
                     description: "A boy runs through a dark and strange world without any words. Puzzles are simple but the atmosphere is very heavy. The ending is one of the weirdest things I have ever seen in a game."),
        FavoriteItem(title: "Journey", subtitle: "Thatgamecompany · 2012", imageName: "journey", rating: 4,
                     steamAppID: 638230, tags: ["Adventure", "Atmospheric", "Multiplayer"],
                     description: "You walk across a desert towards a mountain far away. Sometimes you meet another real player, but you can only talk with musical sounds. The whole game is short and feels like a beautiful dream."),
        FavoriteItem(title: "Firewatch", subtitle: "Campo Santo · 2016", imageName: "firewatch", rating: 3,
                     steamAppID: 383870, tags: ["Walking Simulator", "Mystery", "Story Rich"],
                     description: "Henry takes a summer job as a fire lookout in a Wyoming forest. His only contact is his boss Delilah on the radio. The dialogues feel very natural and the forest looks great."),
        FavoriteItem(title: "Subnautica", subtitle: "Unknown Worlds · 2018", imageName: "subnautica", rating: 4,
                     steamAppID: 264710, tags: ["Survival", "Underwater", "Open World"],
                     description: "Your ship crashes on an ocean planet and you have to survive underwater. You build bases and submarines and go deeper and deeper. The deep ocean with its huge creatures is really scary."),
        FavoriteItem(title: "It Takes Two", subtitle: "Hazelight Studios · 2021", imageName: "it_takes_two", rating: 2,
                     steamAppID: 1426210, tags: ["Co-op", "Adventure", "Platformer"],
                     description: "A married couple is turned into small dolls and must work together to get back. It can only be played in co-op, online or on one screen. The gameplay changes all the time, but the story was not really for me.")
    ]
}
