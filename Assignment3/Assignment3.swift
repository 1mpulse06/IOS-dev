// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

func parseReading(_ raw: String) -> Reading? {
    guard let (sensor, valueString) = splitOnce(raw, by: ":"),
          !sensor.isEmpty,
          let value = Int(valueString),
          value >= 0 || sensor == "TEMP"
    else {
        return nil
    }
    return (sensor: sensor, value: value)
}
if let r1 = parseReading("O2:87") {
    print("Valid: \(r1)")
} else {
    print("Invalid: O2:87")
}

if let r2 = parseReading(":55") {
    print("Valid: \(r2)")
} else {
    print("Invalid: :55")
}

func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }
    return (valid: valid, invalidCount: invalidCount)
}

let A = parseLog(rawLog).invalidCount

print(parseLog(rawLog))
print(A)

// MARK: Level 2 · Analysis


// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}
let validReadings = parseLog(rawLog).valid
let o2Readings = select(validReadings) { $0.sensor == "O2" }
print(o2Readings)

let o2Values = values(of: o2Readings)
print(o2Values)

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard !values.isEmpty else { return nil }

    var minValue = values[0]
    var maxValue = values[0]
    var sum = 0

    for v in values {
        if v < minValue { minValue = v }
        if v > maxValue { maxValue = v }
        sum += v
    }

    let average = Double(sum) / Double(values.count)
    return (min: minValue, max: maxValue, average: average)
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

if let s1 = stats(3, 8, 1) {
    print("stats(3, 8, 1) = \(s1)")
} else {
    print("stats(3, 8, 1) = nil")
}

if let s2 = stats() {
    print("stats() = \(s2)")
} else {
    print("stats() = nil")
}

var B = 0
if let o2Stats = stats(of: o2Values) {
    B = Int(o2Stats.average)
}
print("B = \(B)")

// 2.3 · The Closure Ladder
let sort1 = validReadings.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

let sort2 = validReadings.sorted(by: { (a: Reading, b: Reading) in
    a.value > b.value
})

let sort3 = validReadings.sorted(by: { a, b in
    a.value > b.value
})

let sort4 = validReadings.sorted(by: { $0.value > $1.value })

let sort5 = validReadings.sorted { $0.value > $1.value }

print(values(of: sort1))
print(values(of: sort2))
print(values(of: sort3))
print(values(of: sort4))
print(values(of: sort5))

let allMatch =
    values(of: sort1) == values(of: sort2) &&
    values(of: sort2) == values(of: sort3) &&
    values(of: sort3) == values(of: sort4) &&
    values(of: sort4) == values(of: sort5)

print("All five sorts match: \(allMatch)")

// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    t + 5
}

func coolDown(_ t: Int) -> Int {
    t - 3
}

func hold(_ t: Int) -> Int {
    t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

// тесты
print(heatUp(10))       // 15
print(coolDown(30))     // 27
print(hold(20))         // 20

let protocol1 = chooseProtocol(for: 10)
print(protocol1(10))    // 15 (heatUp)

let protocol2 = chooseProtocol(for: 30)
print(protocol2(30))    // 27 (coolDown)

// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0

    while (temp < 18 || temp > 24) && steps < maxSteps {
        let action = chooseProtocol(for: temp)
        temp = action(temp)
        steps += 1
    }

    let isStable = temp >= 18 && temp <= 24
    return (finalTemp: temp, steps: steps, isStable: isStable)
}

// тесты
print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))

// код C
let tempReadings = select(validReadings) { $0.sensor == "TEMP" }
let tempValues = values(of: tempReadings)

var C = 0
if let tempStats = stats(of: tempValues) {
    let result = runUntilStable(from: tempStats.min)
    C = result.steps
}
print("C = \(C)")
// MARK: Level 4 · The Crew

// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

if let timur = roster["Timur"] {
    print(oxygenLevel(of: timur) as Any)   // Optional(40)
}
if let dana = roster["Dana"] {
    print(oxygenLevel(of: dana) as Any)    // nil
}
if let nurlan = roster["Nurlan"] {
    print(oxygenLevel(of: nurlan) as Any)  // nil
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        let location = member.module?.name ?? "open space"
        return "\(member.name): no data (\(location))"
    }
    let state = level < 20 ? "CRITICAL" : "OK"
    return "\(member.name): \(level)% \(state)"
}

for member in crew {
    print(status(of: member))
}


// 4.3
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }

    let maxCapacity = 100
    let availableToGive = min(amount, source)
    let availableToReceive = maxCapacity - target
    let actualTransfer = min(availableToGive, availableToReceive)

    source -= actualTransfer
    target += actualTransfer

    return actualTransfer
}

// тест: перелить 30 из Lab в Hab
if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let transferred = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
    print("Transferred: \(transferred)")
    print("Lab level: \(labTank.level)")
    print("Hab level: \(habTank.level)")
}

var D = 0
if let habTank = hab.oxygenTank {
    D = habTank.level
}
print("D = \(D)")

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }
    let sorted = found.sorted { $0.priority < $1.priority }
    var result: [String] = []
    for member in sorted {
        result.append(member.name)
    }
    return result
}

// тест
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
// MARK: Level 5 · The Saboteur's Logbook
// Problems found:
// 1. member.module! — crashes if member has no module (Nurlan: module = nil).
// 2. .oxygenTank! — crashes if the module has no tank (Dock, where Dana is).
// 3. oxygenLevel(of: member)! — crashes for anyone with no oxygen data at all (Dana, Nurlan).
// 4. result! — crashes if nobody in the crew is critical (result stays nil).
// 5. LOGIC BUG (not a !): the loop keeps overwriting `result` on every match instead
//    of stopping at the first one, so firstCritical actually returns the LAST
//    critical member, not the first, despite its name.

func reportOxygen(for member: CrewMember) -> String {
    guard let tank = member.module?.oxygenTank else {
        return "\(member.name): no tank data"
    }
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name
        }
    }
    return nil
}

// tests
if let dana = roster["Dana"] {
    print(reportOxygen(for: dana))
}
if let timur = roster["Timur"] {
    print(reportOxygen(for: timur))
}

print(firstCritical(in: crew) as Any)

// test proving the "last instead of first" logic bug is fixed
let critModuleA = Module(name: "TestA", oxygenTank: Tank(level: 5))
let critModuleB = Module(name: "TestB", oxygenTank: Tank(level: 8))
let testCrewMemberA = CrewMember(name: "First", role: "Test", priority: 1, module: critModuleA)
let testCrewMemberB = CrewMember(name: "Second", role: "Test", priority: 2, module: critModuleB)
let testCrew = [testCrewMemberA, testCrewMemberB]

print(firstCritical(in: testCrew) as Any)

// MARK: Finale · Launch Code

 let launchCode = "\(A)-\(B)-\(C)-\(D)"
 print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

// MARK: Bonus
func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0
    return { level in
        if level < threshold {
            count += 1
            print("Alarm #\(count)")
            return true
        }
        return false
    }
}

let alarm = makeAlarm(threshold: 20)
print(alarm(12))   // Alarm #1 → true
print(alarm(40))   // false
print(alarm(5))    // Alarm #2 → true


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 2. Why can't you pass [Int] to stats(_ values: Int...)?

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

 5. Full type of chooseProtocol and how to read it:

 Bonus. Where does the alarm counter live after makeAlarm returns?
/*
 1. guard let разворачивает опциональную переменную в область видимости ПОСЛЕ guard,
    до конца функции — без вложенности. if let разворачивает переменную только
    внутри своего блока { }. Пример, где if let хуже: если нужно проверить 5 условий
    подряд и использовать все переменные дальше — с if let получится "пирамида" из
    5 вложенных блоков, а с guard let — 5 плоских строк подряд.

 2. Потому что stats(_ values: Int...) — вариативный параметр: он ожидает отдельные
    Int-аргументы через запятую (например stats(3, 8, 1)), а не готовый массив.
    Это другая перегрузка функции с другой сигнатурой вызова, компилятор не умеет
    автоматически "распаковать" массив в variadic-параметр.

 3. Потому что inout требует эксклюзивный доступ на запись к памяти на время вызова
    функции. Если передать одну и ту же переменную и как source, и как target,
    компилятор не может гарантировать, что изменения через один параметр не
    столкнутся с изменениями через другой — это защищает от непредсказуемых
    мутаций и багов из-за конфликта за одну и ту же ячейку памяти.

 4. Потому что oxygenLevel(of:) возвращает Int?, а "no data" — это String.
    Оператор ?? требует, чтобы левая и правая часть были одного типа. Здесь
    типы Int? и String не совпадают, поэтому компиляция падает.

 5. Полный тип: (Int) -> (Int) -> Int
    Читается так: chooseProtocol — функция, которая принимает Int (температуру)
    и возвращает ДРУГУЮ функцию; та, в свою очередь, принимает Int и возвращает Int.
    То есть chooseProtocol сначала выбирает протокол, а результат — это функция,
    которую потом можно отдельно применить к температуре.

 Bonus. Счётчик живёт внутри самого closure — он захвачен (captured) по ссылке
 в момент создания closure внутри makeAlarm. Даже после того как makeAlarm
 возвращает управление, Swift держит эту переменную в памяти (heap), пока жива
 хотя бы одна ссылка на closure. Поэтому каждый повторный вызов alarm(...) видит
 обновлённое значение count, а не создаёт его заново.
*/

*/
