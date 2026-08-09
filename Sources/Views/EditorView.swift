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
                // Список глав
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(book.chapters.enumerated()), id: \.element.id) { i, ch in
                            Button {
                                saveCurrent()
                                selectedChapter = i
                                text = book.chapters[i].text
                            } label: {
                                Text(ch.title)
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
                            store.addChapter(to: bookID)
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

                Divider()

                // Редактор
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Начните писать свою историю...")
                            .foregroundColor(Color(.tertiaryLabel))
                            .font(.system(size: fontSize))
                            .padding(.top, 20)
                            .padding(.leading, 20)
                    }

                    ScrollView {
                        TextEditor(text: $text)
                            .font(.system(size: fontSize))
                            .lineSpacing(8)
                            .padding(16)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 400)
                            .onChange(of: text) { _ in
                                saveCurrent()
                            }
                    }
                }

                Divider()

                // Нижняя панель
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
            AIToolsSheet(text: $text, bookID: bookID)
        }
        .onAppear {
            if let book = book, selectedChapter < book.chapters.count {
                text = book.chapters[selectedChapter].text
            }
        }
        .onDisappear { saveCurrent() }
    }

    private func saveCurrent() {
        guard var book = book else { return }
        if selectedChapter < book.chapters.count {
            book.chapters[selectedChapter].text = text
            store.updateBook(book)
        }
    }
}

struct AIToolsSheet: View {
    @Binding var text: String
    let bookID: UUID
    @Environment(\.dismiss) var dismiss

    let tools: [(String, String, String)] = [
        ("🔧", "Исправить ошибки", "fix"),
        ("✨", "Улучшить стиль", "style"),
        ("📉", "Сократить", "shorten"),
        ("➡️", "Продолжить текст", "continue"),
        ("💡", "Идеи для сюжета", "idea"),
        ("👤", "Создать персонажа", "character"),
        ("💬", "Написать диалог", "dialogue"),
        ("😊", "Настроение", "sentiment"),
        ("📊", "Полный анализ", "analyze")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("✨ Улучшение текста") {
                    ForEach(tools.prefix(4), id: \.2) { tool in
                        Button {
                            // TODO: AI Engine на шаге 2
                            dismiss()
                        } label: {
                            HStack {
                                Text(tool.0)
                                Text(tool.1).foregroundColor(.primary)
                            }
                        }
                    }
                }
                Section("💡 Генерация") {
                    ForEach(tools[4..<7], id: \.2) { tool in
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Text(tool.0)
                                Text(tool.1).foregroundColor(.primary)
                            }
                        }
                    }
                }
                Section("📊 Анализ") {
                    ForEach(tools[7...], id: \.2) { tool in
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Text(tool.0)
                                Text(tool.1).foregroundColor(.primary)
                            }
                        }
                    }
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
}
