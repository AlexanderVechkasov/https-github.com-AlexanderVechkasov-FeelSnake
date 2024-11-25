//
//  Untitled.swift
//  FeelSnake
//
//  Created by Александр Вечкасов on 25.11.2024.
//

import SwiftUI

// Кнопка меню с общим стилем
struct GradientButton: View {
    let title: String
    let systemImageName: String
    let action: () -> Void
    let accessibilityLabel: String

    @State private var isPressed = false
    @State private var isHovered = false

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                    action()
                }
            }
        }) {
            HStack {
                Image(systemName: systemImageName)
                    .font(.title)
                    .foregroundColor(.white)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            // Уменьшенные отступы
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.68, green: 1.0, blue: 0.18),Color(red: 0.0, green: 0.5, blue: 0.0)]), startPoint: .topLeading,endPoint: .bottomTrailing).opacity(0.8)
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .shadow(color: Color.white.opacity(0.5), radius: 1, x: 0, y: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isHovered ? 0.9 : 1.0)
        }
        .accessibility(label: Text(accessibilityLabel))
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
    }
}

// Кнопка с иконкой и общим стилем
struct IconButton: View {
    let systemImageName: String
    let action: () -> Void
    let accessibilityLabel: String

    @State private var isPressed = false
    @State private var isHovered = false

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    action()
                }
            }
        }) {
            Image(systemName: systemImageName)
                .font(.title)
                .foregroundColor(.white)
                // Уменьшенный отступ
                .padding(10)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.68, green: 1.0, blue: 0.18),
                                                               Color(red: 0.0, green: 0.5, blue: 0.0)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .opacity(0.8)
                )
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .shadow(color: Color.white.opacity(0.5), radius: 1, x: 0, y: 1)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(isHovered ? 0.9 : 1.0)
        }
        .accessibility(label: Text(accessibilityLabel))
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
    }
}

// Компонент для заголовка с фоном
struct TitleTextWithBackground: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("MarkerFelt-Wide", size: 40))
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.darkGreen.opacity(0.8),
                                                           Color.green.opacity(0.8)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 10, x: 0, y: 5)
                    .opacity(0.8)
            )
            .padding(.bottom, 20)
    }
}

// Компонент для заголовка с общим стилем
struct TitleText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 50, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding()
    }
}

// Расширение для кастомных цветов
extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
    static let oliveGreen = Color(red: 0.5, green: 0.5, blue: 0.0)
    static let brown = Color(red: 0.65, green: 0.16, blue: 0.16)
}
