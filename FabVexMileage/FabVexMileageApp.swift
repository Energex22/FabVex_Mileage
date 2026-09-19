import SwiftUI
import SwiftData

@main
struct FabVexMileageApp: App {
    @StateObject private var app = AppController()
    var body: some Scene {
        WindowGroup { RootView().environmentObject(app) }
            .modelContainer(for: [WorkSession.self, ScheduledBlock.self, Vehicle.self, GasPrice.self, Expense.self, SavedLocation.self, AppSettings.self])
    }
}

final class AppController: ObservableObject {
    let location = LocationManager()
    @Published var isTracking = false
    init() { location.onTrackingStateChanged = { [weak self] value in self?.isTracking = value } }
}
