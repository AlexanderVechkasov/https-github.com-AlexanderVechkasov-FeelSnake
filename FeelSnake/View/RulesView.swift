//
//  RulesView.swift
//  FeelSnake
//
//  Created by Александр Вечкасов on 25.11.2024.
//

import SwiftUI

struct RulesView: View {
    @ObservedObject var snakeModel: SnakeModel

    var body: some View {
        ZStack {
            Image("rulesBackground") // Фоновое изображение для экрана с правилами
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                TitleTextWithBackground(text: "Правила игры")
                    .padding(.top, 40) // Поднимаем текст вверх

                Text("""
                1. Управляйте змейкой с помощью свайпов или кнопок.
                2. Съедайте еду, чтобы расти.
                3. Избегайте столкновений с границами и своим телом.
                """)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.darkGreen.opacity(0.8), Color.green.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                            .cornerRadius(10)
                            .shadow(color: .green, radius: 10, x: 0, y: 5)
                            .opacity(0.8)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .accessibility(label: Text("Правила игры"))
                    .accessibility(label: Text("""
                1. Управляйте змейкой с помощью свайпов или кнопок.
                2. Съедайте еду, чтобы расти.
                3. Избегайте столкновений с границами и своим телом.
                """))
                GradientButton(title: "Назад", systemImageName: "arrow.backward", action: {
                    snakeModel.isRulesVisible = false
                    snakeModel.isMenuVisible = true
                }, accessibilityLabel: "Назад")
                .padding()
            }
            .padding(.horizontal)
            .padding(.top, 20) // Поднимаем весь контент вверх
            .animation(.easeInOut(duration: 0.5), value: snakeModel.isRulesVisible)
        }
    }
}
