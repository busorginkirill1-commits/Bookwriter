import SwiftUI

@main
struct BookWriterApp: App {
    @StateObject private var store = BookStore()
    @AppStorage("appTheme") private var appTheme = "dark"

    var body: some Scene {
        WindowGroup {
            SplashView {
                ContentView()
                    .environmentObject(store)
                    .preferredColorScheme(
                        appTheme == "dark" ? .dark : .light
                    )
            }
        }
    }
}
