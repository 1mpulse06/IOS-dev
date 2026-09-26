func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    // Вычисляемое свойство только для чтения. switch без default —
    // если добавить новый кейс и забыть его здесь, компилятор выдаст ошибку.
    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab:    return 3
        case .engine: return 4
        case .cargo:  return 5
        }
    }
}

print("\n--- Level 1.1 · Deck register ---")
for deck in Deck.allCases {
    print("Deck \(deck.rawValue): evacuation priority \(deck.evacuationPriority)")
}

// 1.2
// Пишем только green = 0, остальные получают 1, 2, 3 автоматически.
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red

    // static = метод типа, вызывается как AlarmLevel.level(...)
    static func level(forTotalMass mass: Int) -> AlarmLevel {
        var step = mass / 500          // каждые полные 500 кг = +1 ступень
        if step < 0 { step = 0 }       // на всякий случай для отрицательной массы
        if step > 3 { step = 3 }       // всё, что >= 1500 кг, — red
        // AlarmLevel(rawValue:) возвращает optional, поэтому ?? вместо !
        return AlarmLevel(rawValue: step) ?? .red
    }
}

print("\n--- Level 1.2 · AlarmLevel ---")
print("Raw values: green=\(AlarmLevel.green.rawValue), yellow=\(AlarmLevel.yellow.rawValue), orange=\(AlarmLevel.orange.rawValue), red=\(AlarmLevel.red.rawValue)")
print("level(forTotalMass: 0)    -> \(AlarmLevel.level(forTotalMass: 0))")
print("level(forTotalMass: 940)  -> \(AlarmLevel.level(forTotalMass: 940))")
print("level(forTotalMass: 4000) -> \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Уровень 2 · Манифест

// 2.1
// Associated values: каждый кейс несёт свои данные.
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2
// Никогда не падаем и не возвращаем optional: любая ошибка -> .unknown
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)   // fields всегда возвращает хотя бы 1 элемент
    let tag = parts[0]

    switch tag {
    case "crate":
        if parts.count == 3, let id = Int(parts[1]), let massKg = Int(parts[2]) {
            return .crate(id: id, massKg: massKg)
        }
    case "container":
        if parts.count == 3, let massKg = Int(parts[2]) {
            return .container(code: parts[1], massKg: massKg)
        }
    case "livestock":
        if parts.count == 4, let count = Int(parts[2]), let perUnit = Int(parts[3]) {
            return .livestock(species: parts[1], count: count, massPerUnitKg: perUnit)
        }
    default:
        break
    }
    return .unknown(raw: line)
}

// 2.3
// switch + `let` достаёт associated values из кейса.
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("\n--- Level 2 · Manifest ---")
var totalManifestMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    let entryMass = mass(of: entry)
    totalManifestMass += entryMass
    if case .unknown = entry {
        unknownCount += 1
    }
    print("\"\(line)\" -> \(entry) -> \(entryMass) kg")
}
print("Unknown (corrupted) lines: \(unknownCount)")
print("Total manifest mass: \(totalManifestMass) kg")

let A = totalManifestMass   // фрагмент A


// 3.1
// Инициализатор НЕ пишем: структура получает memberwise init бесплатно:
// CrewSnapshot(name:deck:oxygen:)
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    // mutating — метод меняет саму структуру (self)
    mutating func breathe(_ amount: Int) {
        oxygen -= amount
        if oxygen < 0 { oxygen = 0 }
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    // Присваиваем self целиком новое значение
    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

// 3.2
func buildRoster() -> [CrewSnapshot] {
    var result: [CrewSnapshot] = []
    for record in crewData {
        if let deck = Deck(rawValue: record.deck) {
            result.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
        } else {
            print("WARNING: \(record.name) is assigned to unknown deck \"\(record.deck)\" — skipped")
        }
    }
    return result
}

print("\n--- Level 3.2 · Crew roster ---")
let crewRoster: [CrewSnapshot] = buildRoster()
for member in crewRoster {
    print("\(member.name): deck \(member.deck), oxygen \(member.oxygen)")
}

// Методы CrewSnapshot в действии
var rookie = CrewSnapshot.rookie(named: "Arman")
print("Rookie: \(rookie.name), \(rookie.deck), O2 \(rookie.oxygen)")
rookie.breathe(130)
rookie.move(to: .cargo)
print("After breathe(130) + move(to: .cargo): \(rookie.deck), O2 \(rookie.oxygen)")
rookie.reviveInMedbay()
print("After reviveInMedbay(): \(rookie.deck), O2 \(rookie.oxygen)")

// 3.3 · Демонстрация семантики значений (копия / обычный параметр / inout)
print("\n--- Level 3.3 · Value semantics ---")

// 1) Копия
let original = CrewSnapshot(name: "Timur", deck: .engine, oxygen: 62)
var copy = original
print("[copy] before: original O2 = \(original.oxygen), copy O2 = \(copy.oxygen)")
copy.breathe(20)
print("[copy] after:  original O2 = \(original.oxygen), copy O2 = \(copy.oxygen)  <- original unchanged")

// 2) Обычный параметр: функция получает КОПИЮ (параметр — let,
//    поэтому внутри делаем var-копию и меняем её)
func drainPlain(_ crew: CrewSnapshot) {
    var local = crew
    local.breathe(30)
    print("[plain] inside function: O2 = \(local.oxygen)")
}
var dana = CrewSnapshot(name: "Dana", deck: .lab, oxygen: 48)
print("[plain] before: Dana O2 = \(dana.oxygen)")
drainPlain(dana)
print("[plain] after:  Dana O2 = \(dana.oxygen)  <- original unchanged")

// 3) inout: функция работает с оригиналом
func drainInout(_ crew: inout CrewSnapshot) {
    crew.breathe(30)
}
print("[inout] before: Dana O2 = \(dana.oxygen)")
drainInout(&dana)
print("[inout] after:  Dana O2 = \(dana.oxygen)  <- original CHANGED")




final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    // Бонус 1: deinit вызывается, когда на объект больше нет ни одной ссылки
    deinit {
        print("deinit: TeleportPod \(id) destroyed")
    }

    // Нельзя загрузить, если капсула занята или заряд < 20
    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil || chargeLevel < 20 {
            return false
        }
        occupant = crew
        return true
    }

    // Пусто -> nil и заряд не тратится. Успех -> −20, капсула пустеет.
    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else {
            return nil
        }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }
}

// 4.2 · Журнал заряда
print("\n--- Level 4.2 · Charge ledger ---")

func findCrew(named name: String) -> CrewSnapshot? {
    for member in crewRoster {
        if member.name == name {
            return member
        }
    }
    return nil
}

let ledgerPod = TeleportPod(id: "P-1", chargeLevel: 100)
print("Start: charge \(ledgerPod.chargeLevel)")

for name in ["Timur", "Dana", "Nurlan"] {
    if let crew = findCrew(named: name) {
        let loaded = ledgerPod.load(crew)
        let arrived = ledgerPod.fire()
        print("load \(name): \(loaded), fire -> \(arrived?.name ?? "nobody"), charge \(ledgerPod.chargeLevel)")
    } else {
        print("\(name) not found in roster")
    }
}
let emptyShot = ledgerPod.fire()
print("fire on empty pod -> \(emptyShot?.name ?? "nil"), charge \(ledgerPod.chargeLevel)")

let C = ledgerPod.chargeLevel   // фрагмент C

// 4.3 · Демонстрация ссылочной семантики
print("\n--- Level 4.3 · Reference semantics ---")
let podOne = TeleportPod(id: "R-1", chargeLevel: 80)
let podTwo = podOne                       // копируется ССЫЛКА, объект один
print("[class]  before: podOne = \(podOne.chargeLevel), podTwo = \(podTwo.chargeLevel)")
podTwo.chargeLevel = 5
print("[class]  after:  podOne = \(podOne.chargeLevel), podTwo = \(podTwo.chargeLevel)  <- both changed")

let snapOne = CrewSnapshot(name: "Aigerim", deck: .bridge, oxygen: 91)
var snapTwo = snapOne                     // копируется ЗНАЧЕНИЕ
print("[struct] before: snapOne = \(snapOne.oxygen), snapTwo = \(snapTwo.oxygen)")
snapTwo.oxygen = 5
print("[struct] after:  snapOne = \(snapOne.oxygen), snapTwo = \(snapTwo.oxygen)  <- only the copy changed")




// 5.1
final class Station {
    // Хранимое свойство (let)
    let callSign: String

    // Хранимое свойство (var) — словарь кислорода по палубам
    var oxygenByDeck: [Deck: Int]

    // Хранимое свойство (var) с наблюдателями
    var hullIntegrity: Int {
        willSet {
            print("Hull integrity: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            // Присваивание своему же свойству внутри didSet НЕ вызывает
            // наблюдателей повторно — поэтому бесконечного цикла нет.
            if hullIntegrity > 100 {
                hullIntegrity = 100
            } else if hullIntegrity < 0 {
                hullIntegrity = 0
            }
        }
    }

    // Ленивое хранимое свойство (lazy): вычисляется один раз, при первом обращении
    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        var report = "Diagnostics for \(self.callSign):"
        for deck in Deck.allCases {
            if let oxygen = self.oxygenByDeck[deck] {
                report += " \(deck.rawValue)=\(oxygen)"
            }
        }
        report += " | hull=\(self.hullIntegrity)"
        return report
    }()

    // Вычисляемое свойство, только чтение (без слова get)
    var totalOxygen: Int {
        var sum = 0
        for (_, oxygen) in oxygenByDeck {
            sum += oxygen
        }
        return sum
    }

    // Вычисляемое свойство с get и set (сеттер использует стандартное имя newValue)
    var averageOxygen: Int {
        get {
            if oxygenByDeck.count == 0 { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        var dictionary: [Deck: Int] = [:]
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                dictionary[deck] = reading.oxygen
            } else {
                print("Station \(callSign): skipping reading for unknown deck \"\(reading.deck)\"")
            }
        }
        self.oxygenByDeck = dictionary
        self.hullIntegrity = 100   // в init наблюдатели не срабатывают
    }
}

print("\n--- Level 5.1 · Station ---")
let station = Station(callSign: "ALMA-7", readings: deckReadings)
let B = station.averageOxygen   // фрагмент B — сразу, до любых изменений
print("Call sign: \(station.callSign)")
print("Decks tracked: \(station.oxygenByDeck.count)")
print("Total oxygen: \(station.totalOxygen)")
print("Average oxygen at start-up: \(B)")

// Lazy: до обращения скана нет
print("Station created; fullDiagnostics not touched yet (no scan above).")
print("First access:  \(station.fullDiagnostics)")
print("Second access: \(station.fullDiagnostics)   <- no second \"Running full scan...\"")

// Вторая станция: fullDiagnostics никогда не трогаем -> скана не будет вообще
let backupStation = Station(callSign: "ALMA-7B", readings: deckReadings)
print("Backup station \(backupStation.callSign) created, diagnostics never accessed -> no scan printed.")
// Сеттер averageOxygen — на резервной станции, чтобы не трогать B
backupStation.averageOxygen = 70
print("Backup after averageOxygen = 70: total \(backupStation.totalOxygen), average \(backupStation.averageOxygen)")

// 5.2 · Ловушка ограничения (clamp)
print("\n--- Level 5.2 · Clamp trap ---")
station.hullIntegrity = 130
print("hullIntegrity after 130: \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hullIntegrity after -40: \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hullIntegrity after 55:  \(station.hullIntegrity)")
// Почему нет бесконечного цикла: Swift не вызывает willSet/didSet,
// когда свойство присваивается внутри его собственного наблюдателя.
// Присваивание в didSet просто записывает значение в хранилище.


// MARK: Уровень 6 · Отчёты об инцидентах
// Три фрагмента компилируются, но работают неправильно. Один не компилируется.
// Для каждого: ожидание, реальное поведение, правило языка, исправление.

/*
// Отчёт 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // автор ожидал, что у экипажа уменьшится кислород

// Отчёт 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // автор ожидал 100

// Отчёт 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}

// Отчёт 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10


//
 ОТЧЁТ 1 — компилируется, но неправильно.
   Ожидание: у всех в roster станет на 10 меньше кислорода.
   На деле:  roster[0].oxygen не изменился (62).
   Правило:  CrewSnapshot — struct (value type). `for var member in roster`
             даёт КОПИЮ каждого элемента; меняется копия, массив — нет.
   Fix:      менять элементы массива по индексу (см. код ниже).

 ОТЧЁТ 2 — компилируется, но неправильно.
   Ожидание: podA.chargeLevel останется 100.
   На деле:  печатается 0.
   Правило:  TeleportPod — class (reference type). `let podB = podA`
             копирует ссылку, оба имени указывают на ОДИН объект.
   Fix:      создать отдельный объект для podB (см. код ниже).

 ОТЧЁТ 3 — НЕ компилируется.
   Ошибка:   "cannot use mutating member on immutable value: 'self' is immutable"
   Правило:  в struct обычный метод видит self как константу. Чтобы менять
             свойства, метод нужно пометить `mutating`.
   Fix:      `mutating func add(...)` (см. код ниже).

 ОТЧЁТ 4 — первая часть НЕ компилируется, вторая компилируется.
   snapshot.oxygen = 40 -> ошибка "cannot assign to property: 'snapshot' is a 'let' constant"
     (нельзя присвоить свойству: 'snapshot' — константа 'let').
     Для struct `let` замораживает всё значение целиком, включая var-свойства.
   pod.chargeLevel = 10 -> OK.
     Для class `let` замораживает только ССЫЛКУ (нельзя написать pod = другойPod),
     а сам объект в куче менять можно, т.к. chargeLevel — var.
   Fix:      `var snapshot = ...` (см. код ниже). Для pod исправлять нечего.
   (Отчёт 3 и первая строка отчёта 4 — оба ошибки компиляции; по условию
    "один не компилируется" имеется в виду отчёт 3 как целый фрагмент,
    а отчёт 4 показывает разницу let для struct и class.)
*/

print("\n--- Level 6 · Fixed incident reports ---")

// Исправление 1
var fixedRoster = crewRoster
print("Report 1 fix — before: \(fixedRoster[0].name) O2 = \(fixedRoster[0].oxygen)")
for index in 0..<fixedRoster.count {
    fixedRoster[index].oxygen -= 10
}
print("Report 1 fix — after:  \(fixedRoster[0].name) O2 = \(fixedRoster[0].oxygen)")

// Исправление 2
let fixedPodA = TeleportPod(id: "A", chargeLevel: 100)
let fixedPodB = TeleportPod(id: "B", chargeLevel: fixedPodA.chargeLevel)  // отдельный объект
fixedPodB.chargeLevel = 0
print("Report 2 fix — podA = \(fixedPodA.chargeLevel), podB = \(fixedPodB.chargeLevel)")

// Исправление 3
struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var logbook = Logbook()
logbook.add("Teleporter offline")
logbook.add("Crew accounted for")
print("Report 3 fix — logbook has \(logbook.entries.count) entries: \(logbook.entries)")

// Исправление 4
var fixedSnapshot = CrewSnapshot.rookie(named: "Dana")
fixedSnapshot.oxygen = 40
let fixedPod = TeleportPod(id: "B", chargeLevel: 50)
fixedPod.chargeLevel = 10
print("Report 4 fix — snapshot O2 = \(fixedSnapshot.oxygen), pod charge = \(fixedPod.chargeLevel)")


// MARK: Уровень 7 ·
final class FlightRecorder {
    // private: снаружи нельзя ни прочитать, ни заменить, ни очистить список записей
    private var entries: [String] = []

    // private(set): снаружи можно только читать; вернуть false извне нельзя
    private(set) var isSealed = false

    // internal: разрешает внешнему коду узнать количество записей (только чтение)
    internal var entryCount: Int {
        return entries.count
    }

    // internal: разрешает читать отформатированный журнал, но не менять его
    internal var transcript: String {
        var text = ""
        for (index, entry) in entries.enumerated() {
            text += "\(index + 1). \(entry)\n"
        }
        return text
    }

    // internal: единственный путь добавить запись; после запечатывания запись отклоняется
    @discardableResult
    internal func add(_ entry: String) -> Bool {
        if isSealed {
            print("FlightRecorder: rejected \"\(entry)\" — recorder is sealed")
            return false
        }
        entries.append(entry)
        return true
    }

    // internal: запечатывает журнал; метода "распечатать" нет вообще
    internal func seal() {
        isSealed = true
    }

    // fileprivate: виден только внутри этого файла (для auditTranscript), но не другим файлам модуля
    fileprivate func auditLines() -> [String] {
        return entries
    }
}

// Свободная функция в этом же файле: использует fileprivate-хелпер.
// С `private` у auditLines() этот вызов не скомпилировался бы.
func auditTranscript(of recorder: FlightRecorder) -> String {
    var result = "AUDIT (\(recorder.isSealed ? "sealed" : "open")):"
    for line in recorder.auditLines() {
        result += " [\(line)]"
    }
    return result
}

print("\n--- Level 7 · Flight recorder ---")
let recorder = FlightRecorder()
recorder.add("Day 10: teleporter reports full crew transfer")
recorder.add("Day 10: Nurlan seen on two decks")
print("Entries: \(recorder.entryCount), sealed: \(recorder.isSealed)")
print(recorder.transcript)
recorder.seal()
recorder.add("Day 11: nothing happened, honest")   // будет отклонено
print("Entries after seal: \(recorder.entryCount), sealed: \(recorder.isSealed)")
print(auditTranscript(of: recorder))

// MARK: Финал ·

print("\n--- Finale ---")
let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Бонус

print("\n--- Bonus · deinit and lifetime ---")
var survivor: TeleportPod? = nil
do {
    let tempPod = TeleportPod(id: "TEMP", chargeLevel: 30)
    survivor = tempPod                        // вторая ссылка на тот же объект
    print("Inside do-block: pod \(tempPod.id) created, 2 references")
}
print("Left do-block: tempPod is gone, but survivor still holds the pod -> no deinit yet")
survivor = nil                                 // <- deinit срабатывает ЗДЕСЬ
print("After survivor = nil: last reference released")

print("\n--- Bonus · === identity ---")
func comparePods(_ first: TeleportPod, _ second: TeleportPod) -> String {
    if first === second {
        return "same pod (one object, two references)"
    }
    if first.id == second.id && first.chargeLevel == second.chargeLevel {
        return "two different pods with equal contents"
    }
    return "two different pods with different contents"
}
let recordOne = TeleportPod(id: "X", chargeLevel: 60)
let recordTwo = recordOne
let recordThree = TeleportPod(id: "X", chargeLevel: 60)
print("recordOne vs recordTwo:   \(comparePods(recordOne, recordTwo))")
print("recordOne vs recordThree: \(comparePods(recordOne, recordThree))")

// MARK: - ================= ВОПРОСЫ ДЛЯ ЗАЩИТЫ =================
/*
 1. Почему CrewSnapshot получил инициализатор бесплатно, а TeleportPod — нет?
    Структуры автоматически получают memberwise-инициализатор
    (CrewSnapshot(name:deck:oxygen:)) по списку своих свойств. Классы такого
    не получают: у классов есть наследование, и компилятор не может знать,
    как правильно инициализировать свойства подклассов/суперкласса. Класс
    получает только пустой init(), если у ВСЕХ свойств есть значения по
    умолчанию. У TeleportPod у id и chargeLevel их нет — значит, init пишем сами.

 2. Что `mutating` делает с self и почему классам он никогда не нужен?
    В обычном методе структуры self — константа. `mutating` делает self
    изменяемым (по сути self передаётся как inout), и метод может менять
    свойства или даже присвоить self целиком (как reviveInMedbay()).
    Классам это не нужно: self у класса — ссылка, а менять объект по ссылке
    можно всегда; сама ссылка при этом не меняется.

 3. В отчёте 4 оба значения объявлены через `let`. Что именно `let`
    замораживает у структуры, а что — у класса?
    struct: `let` замораживает всё значение целиком — нельзя менять ни одно
    свойство, даже объявленное как var (snapshot.oxygen = 40 — ошибка).
    class: `let` замораживает только ссылку — нельзя сделать pod = другойPod,
    но var-свойства объекта менять можно (pod.chargeLevel = 10 — OK).

 4. Почему lazy-свойство обязано быть var? Когда lazy меняет поведение
    программы, а не только производительность?
    lazy-свойство не имеет значения в момент окончания init — оно
    записывается позже, при первом обращении. `let` должен получить значение
    до конца инициализации и больше не меняться, поэтому lazy может быть
    только var.
    Поведение меняется, когда у инициализатора есть побочные эффекты или он
    зависит от состояния: fullDiagnostics печатает "Running full scan..."
    только при первом обращении (а если не обратиться — никогда), и
    захватывает данные станции на момент первого обращения, а не на момент
    создания. Если изменить hullIntegrity ДО первого обращения, в отчёте
    будет новое значение; если после — старое.

 5. private или fileprivate: где в моём FlightRecorder private был бы
    слишком строгим?
    auditLines() используется свободной функцией auditTranscript(of:),
    которая находится вне класса, но в том же файле. С `private` функция
    не смогла бы его вызвать (private виден только внутри типа и его
    расширений в этом файле). fileprivate открывает доступ всему файлу,
    но по-прежнему прячет хелпер от других файлов модуля.

 Бонус. На какой строке срабатывает deinit и почему === нельзя
 использовать для CrewSnapshot?
    deinit срабатывает на строке `survivor = nil`. При выходе из do-блока
    исчезает константа tempPod, но survivor всё ещё держит ссылку
    (счётчик ссылок ARC = 1). Когда survivor = nil, счётчик становится 0,
    и объект уничтожается.
    === сравнивает идентичность объектов (тот же ли это экземпляр в памяти)
    и работает только для классов. CrewSnapshot — struct, value type: у
    значений нет общей идентичности, каждое присваивание создаёт копию.
*/


