import Foundation
import CoreLocation

struct MileageResult { var raw: Double; var filtered: Double; var reconstructed: Double; var confidence: String }
struct MileageEngine {
    static func calculate(_ points: [TrackPoint]) -> MileageResult {
        guard points.count > 1 else { return .init(raw: 0, filtered: 0, reconstructed: 0, confidence: "Low") }
        let sorted = points.sorted { $0.timestamp < $1.timestamp }
        var raw=0.0, filtered=0.0, reconstructed=0.0; var accepted=0; var gaps=0
        for i in 1..<sorted.count {
            let a=sorted[i-1], b=sorted[i]; let d=CLLocation(latitude:a.lat, longitude:a.lon).distance(from: CLLocation(latitude:b.lat, longitude:b.lon)); raw += d/1609.344
            let dt=b.timestamp.timeIntervalSince(a.timestamp); if a.accuracy > 100 || b.accuracy > 100 || d > 1609.344*1.5 { continue }
            if dt > 180 { gaps += 1; let speed = max(a.speed, b.speed); if speed > 0 && speed.isFinite { reconstructed += min(speed*dt/1609.344, 5) } ; continue }
            if d >= 5 || max(a.speed,b.speed) > 2 { filtered += d/1609.344; accepted += 1 }
        }
        let confidence = gaps == 0 && accepted > 0 ? "High" : (gaps <= 2 ? "Moderate" : "Low")
        return .init(raw:raw, filtered:filtered, reconstructed:reconstructed, confidence:confidence)
    }
}
