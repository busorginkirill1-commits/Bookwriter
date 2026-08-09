import SwiftUI

@main
struct BookWriterApp: App {
    @StateObject private var store = BookStore()
    @AppStorage("appTheme") private var appTheme = "dark"
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(store)
                    .preferredColorScheme(appTheme == "dark" ? .dark : .light)

                if showSplash {
                    SplashView {
                        withAnimation(.easeOut(duration: 0.4)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    }
}
