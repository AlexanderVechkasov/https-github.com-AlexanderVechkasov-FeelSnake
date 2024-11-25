//
//  SettingsView.swift
//  FeelSnake
//
//  Created by Александр Вечкасов on 25.11.2024.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @ObservedObject var snakeModel: SnakeModel

    // Добавляем свойства для звуков
    @State private var toggleOnSound: AVAudioPlayer?
    @State private var toggleOffSound: AVAudioPlayer?

    var body: some View {
        ZStack {
            Image("settingsBackground") // Фоновое изображение для экрана настроек
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                TitleTextWithBackground(text: "Настройки")
                    .accessibility(label: Text("Настройки"))

                Toggle("Включить голосовые подсказки", isOn: $snakeModel.isVoiceOverEnabled)
                    .toggleStyle(CustomToggleStyle(toggleAction: { isOn in
                        handleToggleChange(isOn: isOn)
                    }))
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .accessibility(label: Text("Включить голосовые подсказки"))

                // Новый Toggle для инверсии цветов
                Toggle("Инверсия цветов", isOn: $snakeModel.isColorInverted)
                    .toggleStyle(CustomToggleStyle(toggleAction: { isOn in
                        handleToggleChange(isOn: isOn)
                    }))
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .accessibility(label: Text("Инверсия цветов"))

                GradientButton(title: "Назад", systemImageName: "arrow.backward", action: {
                    snakeModel.isSettingsVisible = false
                    snakeModel.isMenuVisible = true
                }, accessibilityLabel: "Назад")
                .padding()
            }
            .padding(.horizontal)
        }
        .onAppear {
            // Загрузка звуков для тумблеров
            toggleOnSound = loadSound(named: "click_on")
            toggleOffSound = loadSound(named: "click_off")
        }
    }

    // Обработчик изменения состояния тумблера
    private func handleToggleChange(isOn: Bool) {
        // Вибрация
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()

        // Воспроизведение звука
        if isOn {
            toggleOnSound?.play()
        } else {
            toggleOffSound?.play()
        }
    }

    // Метод для загрузки звуков
    private func loadSound(named name: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }
}

struct CustomToggleStyle: ToggleStyle {
    // Добавляем замыкание для обработки действия тумблера
    var toggleAction: ((Bool) -> Void)?

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.green : Color.red)
                    .frame(width: 50, height: 30)
                    .shadow(color: .black, radius: 10, x: 0, y: 5)
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: 2)
                            .shadow(color: .black, radius: 10, x: 0, y: 5)
                    )
                Circle()
                    .fill(Color.white)
                    .frame(width: 25, height: 25)
                    .shadow(radius: 2)
                    .padding(5)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(nil, value: configuration.isOn)
            }
            .onTapGesture {
                withAnimation(.linear(duration: 0.2)) {
                    configuration.isOn.toggle()
                    // Вызываем замыкание при изменении состояния тумблера
                    toggleAction?(configuration.isOn)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.darkGreen.opacity(0.8), Color.green.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .cornerRadius(10)
                .shadow(color: .black, radius: 10, x: 0, y: 5)
                .opacity(0.8)
        )
    }
}
