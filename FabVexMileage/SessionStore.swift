import Foundation
import SwiftData
import CoreLocation

@MainActor final class SessionStore: ObservableObject {
    private let context: ModelContext; private let location: LocationManager
    @Published var active: WorkSession?
    private var observers:[NSObjectProtocol]=[]
    init(context: ModelContext, location: LocationManager) { self.context=context; self.location=location; active = try? context.fetch(FetchDescriptor<WorkSession>(predicate:#Predicate{$0.status == "active"}, sortBy:[SortDescriptor(\WorkSession.start, order:.reverse)])).first; observe() }
    private func observe() {
        observers.append(NotificationCenter.default.addObserver(forName:.locationSample, object:nil, queue:.main){ [weak self] n in guard let self, let payload=n.object as? (UUID,[CLLocation]), let s=self.active, payload.0 == s.id else{return}; for l in payload.1 { s.points.append(TrackPoint(timestamp:l.timestamp,lat:l.coordinate.latitude,lon:l.coordinate.longitude,accuracy:l.horizontalAccuracy,speed:max(0,l.speed),course:l.course)); }; self.recalc(s) } )
    }
    private func recalc(_ s:WorkSession) { let r=MileageEngine.calculate(s.points); s.rawMiles=r.raw; s.filteredMiles=r.filtered; s.reconstructedMiles=r.reconstructed; s.finalMiles=max(0,r.filtered+r.reconstructed+s.userAdjustment); s.confidence=r.confidence; try? context.save() }
    func start(source:String, expectedPay:Double?=nil) { guard active == nil else{return}; let s=WorkSession(source:source); s.expectedPay=expectedPay; context.insert(s); try? context.save(); active=s; location.requestPermission(); location.start(session:s) }
    func end() { guard let s=active else{return}; recalc(s); s.end=.now; s.status="completed"; try? context.save(); location.stop(); active=nil }
    func interrupt() { guard let s=active else{return}; s.interrupted=true; s.status="interrupted"; try? context.save(); location.stop(); active=nil }
}
