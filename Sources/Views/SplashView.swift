import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void
    @State private var showTitle = false
    @State private var showSub = false

    private let chars1 = Array("Ты —")
    private let chars2 = Array("писатель")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Text("✍️")
                    .font(.system(size: 72))
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 20)

                HStack(spacing: 0) {
                    ForEach(chars1.indices, id: \.self) { i in
                        Text(String(chars1[i]))
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .opacity(showTitle ? 1 : 0)
                            .offset(y: showTitle ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.7)
                                    .delay(0.1 + Double(i) * 0.12),
                                value: showTitle
                            )
                    }
                }

                HStack(spacing: 0) {
                    ForEach(chars2.indices, id: \.self) { i in
                        Text(String(chars2[i]))
                            .font(.system(size: 52, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .opacity(showTitle ? 1 : 0)
                            .offset(y: showTitle ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.7)
                                    .delay(0.5 + Double(i) * 0.1),
                                value: showTitle
                            )
                    }
                }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .blue, .clear],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(width: showSub ? 120 : 0, height: 2)
                    .padding(.top, 8)

                Text("✧ КАЖДОЕ СЛОВО ИМЕЕТ СИЛУ ✧")
                    .font(.system(size: 13))
                    .tracking(4)
                    .foregroundColor(.gray)
                    .opacity(showSub ? 1 : 0)
                    .padding(.top, 12)
            }
        }
        .onAppear {
            withAnimation { showTitle = true }
            withAnimation(.easeIn.delay(1.8)) { showSub = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                onFinished()
            }
        }
    }
}
