import SwiftUI

struct ExtrasView: View {
    @EnvironmentObject var store: BookStore
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("📝 Заметки").tag(0)
                    Text("🏗️ Скелет").tag(1)
                    Text("💡 Идеи").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.top, 8)

                switch selectedTab {
                case 0: NotesTab()
                case 1: SkeletonTab()
                default: IdeasTab()
                }
            }
            .navigationTitle("Ещё")
        }
    }
}

struct NotesTab: View {
    @EnvironmentObject var store: BookStore
    @State private var input = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                TextField("Быстрая заметка...", text: $input)
                    .textFieldStyle(.roundedBorder)
                Button {
                    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    store.addNote(input)
                    input = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(12)

            if store.notes.isEmpty {
                Spacer()
                Text("📝").font(.system(size: 36))
                Text("Нет заметок").foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(store.notes) { note in
                        HStack {
                            Text(note.text).font(.subheadline)
                            Spacer()
                            Text(note.date, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { idx in
                        idx.forEach { store.deleteNote(store.notes[$0]) }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct SkeletonTab: View {
    @EnvironmentObject var store: BookStore
    @State private var input = ""
    @State private var type: SkeletonType = .chapter

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Picker("", selection: $type) {
                    ForEach(SkeletonType.allCases, id: \.self) { t in
                        Text(t.icon).tag(t)
                    }
                }
                .pickerStyle(.menu)

                TextField("Название...", text: $input)
                    .textFieldStyle(.roundedBorder)

                Button {
                    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    store.addSkeletonItem(type: type, title: input)
                    input = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(12)

            if store.skeleton.isEmpty {
                Spacer()
                Text("🏗️").font(.system(size: 36))
                Text("Создайте структуру книги").foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(store.skeleton) { item in
                        HStack {
                            Text(item.type.icon)
                            VStack(alignment: .leading) {
                                Text(item.title).font(.subheadline)
                                Text(item.type.rawValue)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { idx in
                        idx.forEach { store.deleteSkeletonItem(store.skeleton[$0]) }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct IdeasTab: View {
    @EnvironmentObject var store: BookStore
    @State private var input = ""
    @State private var tag = "💡"
    private let tags = ["📖", "👤", "🌍", "💡", "✍️"]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                TextField("Новая идея...", text: $input)
                    .textFieldStyle(.roundedBorder)

                Picker("", selection: $tag) {
                    ForEach(tags, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
                .pickerStyle(.menu)

                Button {
                    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    store.addIdea(input, tag: tag)
                    input = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(12)

            if store.ideas.isEmpty {
                Spacer()
                Text("💡").font(.system(size: 36))
                Text("Нет идей").foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(store.ideas) { idea in
                        HStack {
                            Text(idea.tag)
                            Text(idea.text).font(.subheadline)
                        }
                    }
                    .onDelete { idx in
                        idx.forEach { store.deleteIdea(store.ideas[$0]) }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
