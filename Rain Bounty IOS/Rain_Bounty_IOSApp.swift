import SwiftUI
import OneSignalFramework
import BackgroundTasks

let rainCheckTaskIdentifier = "com.suryas.RainBountyIOS.rainCheck"

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("d298b3f4-e05e-413c-91b5-d188f8beae0e", withLaunchOptions: launchOptions)
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)

        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: rainCheckTaskIdentifier, using: nil) { task in
            self.handleRainCheckTask(task: task as! BGAppRefreshTask)
        }

        scheduleRainCheckTask()

        return true
    }

    func scheduleRainCheckTask() {
        let request = BGAppRefreshTaskRequest(identifier: rainCheckTaskIdentifier)
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule rain check task: \(error)")
        }
    }

    func handleRainCheckTask(task: BGAppRefreshTask) {
        
        scheduleRainCheckTask()

        let refreshTask = Task {
            let latitude = UserDefaults.standard.double(forKey: "homeLatitude")
            let longitude = UserDefaults.standard.double(forKey: "homeLongitude")

            do {
                let dailyRainData = try await RainwaterHarvestUtil.getRain(latitude: latitude, longitude: longitude, getForecastData: true)
                RainwaterHarvestUtil.checkForRainAndNotify(dailyRainData: dailyRainData)
                task.setTaskCompleted(success: true)
            } catch {
                print("Background rain check failed: \(error)")
                task.setTaskCompleted(success: false)
            }
        }

        
        task.expirationHandler = {
            refreshTask.cancel()
        }
    }
}

@main
struct Rain_Bounty_IOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
