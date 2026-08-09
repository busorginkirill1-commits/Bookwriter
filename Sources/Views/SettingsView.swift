import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme = "dark"
    @AppStorage("editorFont") private var editorFont = "serif"

    var body: some View {
        NavigationStack {
            List {
                Section("🎨 Оформление") {
                    Picker("Тема", selection: $appTheme) {
                        Text("🌙 Тёмная").tag("dark")
                        Text("☀️ Светлая").tag("light")
                    }

                    Picker("Шрифт", selection: $editorFont) {
                        Text("Serif").tag("serif")
                        Text("Sans").tag("sans")
                        Text("Mono").tag("mono")
                    }
                }

                Section("🧠 Модель ИИ") {
                    HStack {
                        Text("Основная модель")
                        Spacer()
                        Text("Не загружена")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    HStack {
                        Text("Быстрая модель")
                        Spacer()
                        Text("Не загружена")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    Text("Модели будут добавлены на следующем шаге")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("ℹ️ О приложении") {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0").foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Для")
                        Spacer()
                        Text("Киры ✍️").foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("⚙️ Настройки")
        }
    }
}
