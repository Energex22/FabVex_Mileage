import Foundation
import SwiftData

@Model final class WorkSession {
    var id: UUID = UUID(); var source: String = "Amazon Flex"; var start: Date = .now; var end: Date?; var status: String = "active"
    var vehicleID: UUID?; var scheduledBlockID: UUID?; var facilityName: String?; var facilityLat: Double?; var facilityLon: Double?
    var rawMiles: Double = 0; var filteredMiles: Double = 0; var reconstructedMiles: Double = 0; var userAdjustment: Double = 0
    var finalMiles: Double = 0; var expectedPay: Double?; var actualPay: Double?; var payAdjustment: Double = 0
    var confidence: String = "High"; var interrupted: Bool = false; var notes: String = ""; var createdAt: Date = .now
    @Relationship(deleteRule: .cascade) var points: [TrackPoint] = []
    init(source: String = "Amazon Flex") { self.source = source }
}

@Model final class TrackPoint {
    var timestamp: Date; var lat: Double; var lon: Double; var accuracy: Double; var speed: Double; var course: Double
    init(timestamp: Date, lat: Double, lon: Double, accuracy: Double, speed: Double, course: Double) { self.timestamp=timestamp; self.lat=lat; self.lon=lon; self.accuracy=accuracy; self.speed=speed; self.course=course }
}

@Model final class ScheduledBlock {
    var id: UUID = UUID(); var date: Date = .now; var start: Date = .now; var expectedDuration: Int = 180; var source: String = "Amazon Flex"; var facilityName: String?; var expectedPay: Double?; var notes: String = ""
}
@Model final class Vehicle { var id: UUID=UUID(); var name="Primary Vehicle"; var fuelType="Gas"; var mpg: Double=16; var odometerEnabled=false; var odometer: Double? }
@Model final class GasPrice { var date: Date=.now; var price: Double=4.09; var vehicleID: UUID? }
@Model final class Expense { var id: UUID=UUID(); var date: Date=.now; var category="Fuel"; var amount: Double=0; var vehicleID: UUID?; var note="" }
@Model final class SavedLocation { var id: UUID=UUID(); var name=""; var kind="Facility"; var lat: Double=0; var lon: Double=0; var radiusFeet: Double=250 }
@Model final class AppSettings {
    var homeLat: Double?; var homeLon: Double?; var homeRadiusFeet: Double=250; var homePrompt=true; var stationaryMinutes=30; var gpsRetention="90 days"; var trackingPreference="Manual"; var notificationsEnabled=true
    var gpsLostNotifications=true; var gpsRestoredNotifications=true; var scheduledNotifications=true; var stationaryNotifications=true; var interruptedNotifications=true; var longSessionNotifications=false
    init() {}
}
