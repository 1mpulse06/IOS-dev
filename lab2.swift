import Playgrounds

#Playground {
    // Задание 1: Массив фруктов
    let fruits = ["Apple", "Banana", "Cherry", "Mango", "Orange"]
    print(fruits[2])

    // Задание 2: Множество чисел
    var favoriteNumbers: Set = [7, 13, 21, 42]
    favoriteNumbers.insert(99)
    print(favoriteNumbers)

    // Задание 3: Словарь языков программирования
    let languages = ["Swift": 2014, "Python": 1991, "Java": 1995]
    print(languages["Swift"]!)

    // Задание 4: Обновление массива цветов
    var colors = ["Red", "Green", "Blue", "Yellow"]
    colors[1] = "Purple"
    print(colors)

    // Medium 1: Пересечение множеств
    let setA: Set = [1, 2, 3, 4]
    let setB: Set = [3, 4, 5, 6]
    print(setA.intersection(setB))

    // Medium 2: Обновление словаря
    var scores = ["Alice": 85, "Bob": 90, "Charlie": 78]
    scores.updateValue(95, forKey: "Bob")
    print(scores)

    // Medium 3: Слияние массивов
    let fruitsA = ["apple", "banana"]
    let fruitsB = ["cherry", "date"]
    print(fruitsA + fruitsB)

    // Hard 1: Добавление ключа в словарь
    var populations = ["USA": 331000000, "Germany": 83000000, "Japan": 125000000]
    populations["Kazakhstan"] = 19000000
    print(populations)

    // Hard 2: Union и Subtract
    let animalsA: Set = ["cat", "dog"]
    let animalsB: Set = ["dog", "mouse"]
    print(animalsA.union(animalsB).subtracting(animalsB))

    // Hard 3: Вложенная коллекция
    let studentGrades = ["Alice": [85, 90, 78], "Bob": [70, 88, 95]]
    print(studentGrades["Alice"]![1])
}
