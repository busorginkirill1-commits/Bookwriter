import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var store: BookStore
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    statsGrid
                    createButton
                    if store.books.isEmpty {
                        emptyState
                    } else {
                        booksList
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("📚 Книги")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showCreate = true } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateBookSheet()
            }
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            StatCard(value: "\(store.books.count)", label: "Книг")
            StatCard(value: "\(store.totalWords)", label: "Слов")
            StatCard(value: "\(store.totalAICalls)", label: "ИИ запросов")
            StatCard(value: "🔥 \(store.streak)", label: "Дней подряд")
        }
    }

    private var createButton: some View {
        Button {
            showCreate = true
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Начать книгу")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("📖").font(.system(size: 48))
            Text("Нет книг").foregroundColor(.secondary)
            Text("Нажмите «Начать книгу»!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }

    private var booksList: some View {
        VStack(spacing: 8) {
            ForEach(store.books) { book in
                NavigationLink(value: book.id) {
                    BookCard(book: book)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: UUID.self) { bookID in
            if let book = store.books.first(where: { $0.id == bookID }) {
                EditorView(bookID: bookID)
            }
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.blue)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BookCard: View {
    let book: Book

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(book.title)
                        .font(.subheadline.bold())
                        .lineLimit(1)
                    Text("\(book.status.icon)")
                        .font(.caption2)
                }
                Text("\(book.totalWords) слов · \(book.chapters.count) глав")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CreateBookSheet: View {
    @EnvironmentObject var store: BookStore
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var status: BookStatus = .start

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Название книги...", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)

                Picker("Статус", selection: $status) {
                    ForEach(BookStatus.allCases, id: \.self) { s in
                        Text("\(s.icon) \(s.rawValue)").tag(s)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Button {
                    let t = title.trimmingCharacters(in: .whitespaces)
                    store.addBook(title: t.isEmpty ? "Новая книга" : t, status: status)
                    dismiss()
                } label: {
                    Text("Создать")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(20)
            .navigationTitle("📖 Новая книга")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
