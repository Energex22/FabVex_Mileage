import Foundation
import CoreLocation
import UserNotifications

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager(); private var sessionID: UUID?; private var last: CLLocation?
    var onTrackingStateChanged: ((Bool)->Void)?
    @Published private(set) var tracking=false; @Published private(set) var authorization=CLAuthorizationStatus.notDetermined
    override init() { super.init(); manager.delegate=self; manager.desiredAccuracy=kCLLocationAccuracyBest; manager.distanceFilter=5; manager.allowsBackgroundLocationUpdates=true; manager.pausesLocationUpdatesAutomatically=false; authorization=manager.authorizationStatus }
    func requestPermission() { manager.requestAlwaysAuthorization() }
    func start(session: WorkSession) { sessionID=session.id; tracking=true; manager.startUpdatingLocation(); onTrackingStateChanged?(true) }
    func stop() { manager.stopUpdatingLocation(); tracking=false; sessionID=nil; onTrackingStateChanged?(false) }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { authorization=manager.authorizationStatus }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { guard tracking, let sid=sessionID else{return}; NotificationCenter.default.post(name:.locationSample, object:(sid,locations)) }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { NotificationCenter.default.post(name:.gpsLost, object:error.localizedDescription) }
}
extension Notification.Name { static let locationSample=Notification.Name("FVLocationSample"); static let gpsLost=Notification.Name("FVGPSLost") }
