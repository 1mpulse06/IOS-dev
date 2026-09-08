import Playgrounds

#Playground {
    let firstName: String = "Alikhan"
    let lastName: String = "Maratov"
    let birthYear: Int = 2003
    var age: Int = 21
    let isStudent: Bool = true
    let height: Double = 1.78
    let city: String = "Almaty"
    let currentYear: Int = 2026
    age = currentYear - birthYear
    let hobby: String = "play cs"
    let numberOfHobbies: Int = 5
    let favoriteNumber: Int = 7
    let isHobbyCreative: Bool = true
    let lifeStory: String = "My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). I enjoy \(hobby), which is a creative hobby. I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber)."
    print(lifeStory)
    let futureGoals: String = "In the future, I want to become a professional iOS developer 🚀."
    let 🎯: String = "Ship my first app on the App Store"
    let fullStory: String = lifeStory + "\n" + futureGoals + "\nMy goal: \(🎯) 🎯"
    print(fullStory)
}
