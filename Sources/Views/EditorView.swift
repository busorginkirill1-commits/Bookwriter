import SwiftUI

struct EditorView: View {
    @EnvironmentObject var store: BookStore
    let bookID: UUID
    @State private var selectedChapter: Int = 0
    @State private var showTools = false
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 17

    private var book: Book? {
        store.books.first(where: { $0.id == bookID })
    }

    var body: some View {
        VStack(spacing: 0) {
            if let book = book {
                chapterBar(book: book)
                Divider()
                editorArea
                Divider()
                bottomBar
            }
        }
        .navigationTitle(book?.title ?? "Книга")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showTools = true } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showTools) {
            AIToolsSheet()
        }
        .onAppear {
            if let book = book, selectedChapter < book.chapters.count {
                text = book.chapters[selectedChapter].text
            }
        }
        .onDisappear { saveCurrent() }
    }

    private func chapterBar(book: Book) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(book.chapters.indices, id: \.self) { i in
                    Button {
                        saveCurrent()
                        selectedChapter = i
                        text = book.chapters[i].text
                    } label: {
                        Text(book.chapters[i].title)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                i == selectedChapter
                                    ? Color.blue.opacity(0.15)
                                    : Color(.tertiarySystemFill)
                            )
                            .foregroundColor(
                                i == selectedChapter ? .blue : .primary
                            )
                            .clipShape(Capsule())
                    }
                }

                Button {
                    saveCurrent()
                    store.addChapter(to: bookID)
                    if let b = store.books.first(where: { $0.id == bookID }) {
                        selectedChapter = b.chapters.count - 1
                        text = ""
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.bold())
                        .padding(8)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }

    private var editorArea: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text("Начните писать свою историю...")
                    .foregroundColor(Color(.tertiaryLabel))
                    .font(.system(size: fontSize))
                    .padding(.top, 24)
                    .padding(.leading, 20)
            }

            TextEditor(text: $text)
                .font(.system(size: fontSize))
                .lineSpacing(8)
                .padding(.horizontal, 16)
                .scrollContentBackground(.hidden)
                .onChange(of: text) { _ in
                    saveCurrent()
                }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button { fontSize = max(12, fontSize - 1) } label: {
                Text("A−").font(.caption.bold())
            }

            Text("\(text.split(separator: " ").count) слов")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())

            Button { fontSize = min(28, fontSize + 1) } label: {
                Text("A+").font(.caption.bold())
            }

            Spacer()

            Button { showTools = true } label: {
                Image(systemName: "wand.and.stars")
                    .font(.body)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }

    private func saveCurrent() {
        guard var book = book else { return }
        if selectedChapter < book.chapters.count {
            book.chapters[selectedChapter].text = text
            store.updateBook(book)
        }
    }
}

struct AITool: Identifiable {
    let id: String
    let icon: String
    let name: String
}

struct AIToolsSheet: View {
    @Environment(\.dismiss) var dismiss

    private let improveTools: [AITool] = [
        AITool(id: "fix", icon: "🔧", name: "Исправить ошибки"),
        AITool(id: "style", icon: "✨", name: "Улучшить стиль"),
        AITool(id: "shorten", icon: "📉", name: "Сократить"),
        AITool(id: "continue", icon: "➡️", name: "Продолжить текст")
    ]

    private let generateTools: [AITool] = [
        AITool(id: "idea", icon: "💡", name: "Идеи для сюжета"),
        AITool(id: "character", icon: "👤", name: "Создать персонажа"),
        AITool(id: "dialogue", icon: "💬", name: "Написать диалог")
    ]

    private let analyzeTools: [AITool] = [
        AITool(id: "sentiment", icon: "😊", name: "Настроение"),
        AITool(id: "genre", icon: "📚", name: "Жанр"),
        AITool(id: "analyze", icon: "📊", name: "Полный анализ")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("✨ Улучшение текста") {
                    toolButtons(improveTools)
                }
                Section("💡 Генерация") {
                    toolButtons(generateTools)
                }
                Section("📊 Анализ") {
                    toolButtons(analyzeTools)
                }
            }
            .navigationTitle("⚙️ Инструменты")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("✕") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func toolButtons(_ tools: [AITool]) -> some View {
        ForEach(tools) { tool in
            Button {
                // ИИ подключим на следующем шаге
                dismiss()
            } label: {
                HStack {
                    Text(tool.icon)
                    Text(tool.name).foregroundColor(.primary)
                }
            }
        }
    }
}
