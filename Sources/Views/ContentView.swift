import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: BookStore

    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Книги", systemImage: "books.vertical")
                }

            ChatView()
                .tabItem {
                    Label("Чат", systemImage: "bubble.left.and.bubble.right")
                }

            ExtrasView()
                .tabItem {
                    Label("Ещё", systemImage: "square.grid.2x2")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
        }
        .tint(.blue)
    }
}
