import Foundation
import SwiftUI

class BookStore: ObservableObject {
    @Published var books: [Book] = []
    @Published var notes: [Note] = []
    @Published var skeleton: [SkeletonItem] = []
    @Published var ideas: [Idea] = []
    @Published var chatHistory: [ChatMessage] = []
    @Published var streak: Int = 0
    @Published var totalAICalls: Int = 0

    private var docsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    init() {
        loadAll()
        updateStreak()
    }

    // ── Книги ────────────────────────────────────
    func addBook(title: String, status: BookStatus) {
        let book = Book(title: title, status: status)
        books.insert(book, at: 0)
        saveAll()
    }

    func updateBook(_ book: Book) {
        if let i = books.firstIndex(where: { $0.id == book.id }) {
            var b = book
            b.updatedAt = Date()
            books[i] = b
            saveAll()
        }
    }

    func deleteBook(_ book: Book) {
        books.removeAll { $0.id == book.id }
        saveAll()
    }

    func addChapter(to bookID: UUID) {
        if let i = books.firstIndex(where: { $0.id == bookID }) {
            books[i].chapters.append(Chapter())
            saveAll()
        }
    }

    func deleteChapter(bookID: UUID, chapterID: UUID) {
        if let i = books.firstIndex(where: { $0.id == bookID }) {
            books[i].chapters.removeAll { $0.id == chapterID }
            saveAll()
        }
    }

    // ── Заметки ──────────────────────────────────
    func addNote(_ text: String) {
        notes.insert(Note(text: text), at: 0)
        saveAll()
    }

    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveAll()
    }

    // ── Скелет ───────────────────────────────────
    func addSkeletonItem(type: SkeletonType, title: String) {
        skeleton.insert(SkeletonItem(type: type, title: title), at: 0)
        saveAll()
    }

    func deleteSkeletonItem(_ item: SkeletonItem) {
        skeleton.removeAll { $0.id == item.id }
        saveAll()
    }

    // ── Идеи ─────────────────────────────────────
    func addIdea(_ text: String, tag: String) {
        ideas.insert(Idea(text: text, tag: tag), at: 0)
        saveAll()
    }

    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        saveAll()
    }

    // ── Стрик ────────────────────────────────────
    func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        let key = "lastWriteDate"
        let defaults = UserDefaults.standard

        if let lastStr = defaults.string(forKey: key),
           let lastDate = ISO8601DateFormatter().date(from: lastStr) {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if diff == 1 {
                streak += 1
            } else if diff > 1 {
                streak = 1
            }
        } else {
            streak = 1
        }

        defaults.set(ISO8601DateFormatter().string(from: today), forKey: key)
    }

    // ── Сохранение / Загрузка ────────────────────
    private func saveAll() {
        let data = AppDataFile(
            books: books, notes: notes, skeleton: skeleton,
            ideas: ideas, chatHistory: chatHistory,
            streak: streak, totalAICalls: totalAICalls
        )
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: docsURL.appendingPathComponent("appdata.json"))
        }
    }

    private func loadAll() {
        let url = docsURL.appendingPathComponent("appdata.json")
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(AppDataFile.self, from: data)
        else { return }

        books = decoded.books
        notes = decoded.notes
        skeleton = decoded.skeleton
        ideas = decoded.ideas
        chatHistory = decoded.chatHistory
        streak = decoded.streak
        totalAICalls = decoded.totalAICalls
    }

    var totalWords: Int {
        books.reduce(0) { $0 + $1.totalWords }
    }
}

private struct AppDataFile: Codable {
    var books: [Book]
    var notes: [Note]
    var skeleton: [SkeletonItem]
    var ideas: [Idea]
    var chatHistory: [ChatMessage]
    var streak: Int
    var totalAICalls: Int
}
