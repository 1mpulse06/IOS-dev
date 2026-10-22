let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 60),
    (kind: "welder",  id: "W-2", charge: 30),
    (kind: "toaster", id: "T-0", charge: 50),
    (kind: "scanner", id: "S-2", charge: 15)
]

let sensorData: [(id: String, charge: Int)] = [
    (id: "HULL-A", charge: 72),
    (id: "HULL-B", charge: 18)
]

struct LegacyBeacon {
    let serial: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(serial: "BCN-1987", signalStrength: 35)

extension Int {

    func clamped(to range: ClosedRange<Int>) -> Int {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }

    
    func recharged(by amount: Int) -> Int {
        guard amount > 0 else { return self }
        return (self + amount).clamped(to: 0...100)
    }
}


final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        self.charge = charge.clamped(to: 0...100)
    }

    func level() -> Int {
        return charge
    }

    func spend(_ amount: Int) -> Bool {
        guard amount > 0, amount <= charge else { return false }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        charge = charge.recharged(by: amount)
    }
}

class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        let level = cell.level()
        return "\(id): \(level)% \(level.powerBar)"
    }

    func performTask() -> Int { 0 }

    /// "Enough charge for one more task" — the rule lives here, once.
    var canRunTask: Bool {
        return cell.level() >= powerCost
    }

    final func runOnce() -> Int {
        guard cell.spend(powerCost) else { return 0 }
        return performTask()
    }
}


final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }

    func weldSeam() -> String {
        return "\(id) welded a hull seam"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}


func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":  return WelderDrone(id: id, cell: cell)
    case "scanner": return ScannerDrone(id: id, cell: cell)
    case "cargo":   return CargoDrone(id: id, cell: cell)
    default:        return nil
    }
}

var stationFleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        stationFleet.append(drone)
    } else {
        print("WARNING: skipped record \(record.id) — unknown kind \"\(record.kind)\"")
    }
}


func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var total = 0
    for _ in 0..<max(rounds, 0) {
        for drone in fleet {
            total += drone.runOnce()   // one call, different behaviour per object
        }
    }
    return total
}

let A = runShift(stationFleet, rounds: 3)

print("\n=== AFTER SHIFT (3 rounds) ===")
var totalCharge = 0
var readyCount = 0
for drone in stationFleet {
    print(drone.statusLine)
    totalCharge += drone.cell.level()
    if drone.canRunTask {
        readyCount += 1
    }
}
let B = totalCharge
let C = readyCount

print("Total work units: \(A)")
print("Drones ready for one more task: \(C)")



protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}


protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    var statusCode: Int { healthCode(for: cell.level()) }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String { id }
    var statusCode: Int { healthCode(for: chargeLevel) }

    mutating func recharge(by amount: Int) {
        chargeLevel = chargeLevel.recharged(by: amount)
    }
}

var sensors: [SensorModule] = []
for record in sensorData {
    sensors.append(SensorModule(id: record.id, chargeLevel: record.charge))
}


func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "=== DIAGNOSTICS (\(components.count) components) ===\n"
    var problems = 0
    for component in components {
        report += component.diagnose() + "\n"
        if component.statusCode > 0 {
            problems += 1
        }
    }
    report += "Components needing attention: \(problems)"
    return report
}

var diagnosticsList: [Diagnosable] = []
for drone in stationFleet { diagnosticsList.append(drone) }
for sensor in sensors { diagnosticsList.append(sensor) }

print("")
print(diagnosticsReport(diagnosticsList))


extension Diagnosable {
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }

    func healthCode(for level: Int) -> Int {
        if level < 20 { return 2 }   // critical
        if level < 50 { return 1 }   // warning
        return 0                      // nominal
    }
}


extension LegacyBeacon: Diagnosable {
    var componentID: String { serial }
    var statusCode: Int { healthCode(for: signalStrength) }

    func diagnose() -> String {
        return "*** LEGACY HARDWARE *** beacon \(componentID) | signal \(signalStrength) "
            + "\(signalStrength.powerBar) | code \(statusCode) | manual inspection required"
    }
}

diagnosticsList.append(beacon)
print("")
print(diagnosticsReport(diagnosticsList))

var statusSum = 0
for component in diagnosticsList {
    statusSum += component.statusCode
}
let D = statusSum


extension Int {
    /// 42 -> "####......" ; -5 -> ".........." ; 250 -> "##########"
    var powerBar: String {
        let filled = (self / 10).clamped(to: 0...10)
        var bar = ""
        for position in 0..<10 {
            bar += position < filled ? "#" : "."
        }
        return bar
    }
}


print("")
for drone in stationFleet {
    if let welder = drone as? WelderDrone {
        print(welder.weldSeam())
    }
}



let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("\nMISSION CODE: \(missionCode)")


//бонус а
class GuardedDrone {
    init() {
        precondition(type(of: self) != GuardedDrone.self,
                     "GuardedDrone is abstract — instantiate a subclass")
    }

    func performTask() -> Int {
        fatalError("Subclasses must override performTask()")
    }
}

// бонус 2
protocol DroneUnit: Diagnosable {
    var id: String { get }
    var cell: PowerCell { get }
    var powerCost: Int { get }
    func performTask() -> Int
}

extension DroneUnit {
    var componentID: String { id }
    var statusCode: Int { healthCode(for: cell.level()) }
    var powerCost: Int { 10 }

    func runOnce() -> Int {
        guard cell.spend(powerCost) else { return 0 }
        return performTask()
    }
}

struct WelderUnit: DroneUnit {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 25 }
    func performTask() -> Int { 40 }
    func weldSeam() -> String { "\(id) welded a hull seam" }
}

struct ScannerUnit: DroneUnit {
    let id: String
    let cell: PowerCell
    func performTask() -> Int { 15 }
}

let bonusFleet: [DroneUnit] = [
    WelderUnit(id: "BW-1", cell: PowerCell(charge: 60)),
    ScannerUnit(id: "BS-1", cell: PowerCell(charge: 25))
]
var bonusWork = 0
for _ in 0..<3 {
    for unit in bonusFleet {
        bonusWork += unit.runOnce()
    }
}
print("\n[BONUS] protocol-based fleet produced \(bonusWork) work units")
for unit in bonusFleet {
    print("[BONUS] " + unit.diagnose())
}
