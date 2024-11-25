
//
//  MainMenuIView.swift
//  FeelSnake
//
//  Created by Александр Вечкасов on 25.11.2024.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @ObservedObject var snakeModel: SnakeModel

    // Добавляем свойства для звука
    @State private var toggleOnSound: AVAudioPlayer?
    @State private var toggleOffSound: AVAudioPlayer?

    var body: some View {
        ZStack {
            Image("background") // Фоновое изображение для главного меню
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Кнопка голосовых подсказок в верхнем правом углу
            VStack {
                HStack {
                    Spacer()
                    IconButton(
                        systemImageName: snakeModel.isVoiceOverEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill",
                        action: {
                            snakeModel.isVoiceOverEnabled.toggle()

                            // Добавляем вибрацию
                            let feedbackGenerator = UINotificationFeedbackGenerator()
                            feedbackGenerator.prepare()
                            if snakeModel.isVoiceOverEnabled {
                                // Одинарная вибрация для включения
                                feedbackGenerator.notificationOccurred(.success)
                                // Воспроизводим звук включения
                                toggleOnSound?.play()
                            } else {
                                // Двойная вибрация для отключения
                                feedbackGenerator.notificationOccurred(.warning)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    feedbackGenerator.notificationOccurred(.warning)
                                }
                                // Воспроизводим звук отключения
                                toggleOffSound?.play()
                            }
                        },
                        accessibilityLabel: snakeModel.isVoiceOverEnabled ? "Отключить голосовые подсказки" : "Включить голосовые подсказки"
                    )
                    .padding(.top, 3)
                    .padding(.trailing, 3)
                }
                Spacer()
            }

            VStack {
                GradientButton(title: "Начать игру", systemImageName: "play.fill", action: {
                    snakeModel.isMenuVisible = false
                    snakeModel.resetGame()
                }, accessibilityLabel: "Начать игру")
                .padding()

                GradientButton(title: "Правила", systemImageName: "info.circle", action: {
                    snakeModel.isRulesVisible = true
                    snakeModel.isMenuVisible = false
                }, accessibilityLabel: "Правила")
                .padding()

                GradientButton(title: "Настройки", systemImageName: "gearshape.fill", action: {
                    snakeModel.isSettingsVisible = true
                    snakeModel.isMenuVisible = false
                }, accessibilityLabel: "Настройки")
                .padding()

                GradientButton(title: "Выход", systemImageName: "xmark.circle.fill", action: {
                    exit(0)
                }, accessibilityLabel: "Выход")
                .padding()
            }
        }
        .onAppear {
            // Загрузка звуков для тумблера
            toggleOnSound = loadSound(named: "click_on")
            toggleOffSound = loadSound(named: "click_off")
        }
    }

    // Метод для загрузки звуков
    private func loadSound(named name: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }
}
