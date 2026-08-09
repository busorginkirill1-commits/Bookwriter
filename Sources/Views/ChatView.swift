import SwiftUI

struct ChatView: View {
    @EnvironmentObject var store: BookStore
    @State private var input = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(role: "assistant",
                    text: "🤖 Привет! Я ИИ-помощник писателя. Спроси про сюжет, персонажей, диалоги!")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(messages) { msg in
                                ChatBubble(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(12)
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()

                HStack(spacing: 8) {
                    TextField("Спроси у ИИ...", text: $input)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)

                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(12)
                .background(Color(.systemBackground))
            }
            .navigationTitle("💬 Чат с ИИ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func send() {
        let text = input.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        messages.append(ChatMessage(role: "user", text: text))
        input = ""

        // TODO: заменить на локальный ИИ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = SimpleAIReply(text)
            messages.append(ChatMessage(role: "assistant", text: reply))
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == "user" { Spacer(minLength: 60) }

            Text(message.text)
                .font(.system(size: 14))
                .lineSpacing(4)
                .padding(10)
                .background(
                    message.role == "user"
                        ? Color.blue
                        : Color(.secondarySystemFill)
                )
                .foregroundColor(message.role == "user" ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if message.role == "assistant" { Spacer(minLength: 60) }
        }
    }
}

func SimpleAIReply(_ msg: String) -> String {
    let l = msg.lowercased()
    if l.contains("привет") {
        return "Привет! ✨ Чем помочь? Могу помочь с сюжетом, персонажами, диалогами!"
    }
    if l.contains("идея") || l.contains("сюжет") {
        return "💡 Попробуй: персонаж просыпается в мире, где мечты стали реальностью, но за каждую нужно заплатить воспоминаниями."
    }
    if l.contains("персонаж") || l.contains("герой") {
        return "👤 Создай противоречие: сильный воин, но панически боится темноты. Злодей, который считает себя героем."
    }
    if l.contains("диалог") {
        return "💬 Хороший диалог — конфликт:\n— Ты не понимаешь, что делаешь!\n— А ты понимаешь? Ты думаешь, я хочу этого?"
    }
    return "📝 Интересная мысль! Спроси про идеи, персонажей, диалоги или концовку."
}
