//
//  GameView.swift
//  FeelSnake
//
//  Created by Александр Вечкасов on 25.11.2024.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var snakeModel: SnakeModel
    var geometry: GeometryProxy

    var body: some View {
        ZStack {
            VStack {
                topBar
                Spacer()
                gameField
                Spacer()
            }
            if snakeModel.isGameOver {
                gameOverScreen
            }
        }
    }

    // Верхняя панель с кнопкой "Назад" и текущим счетом
    private var topBar: some View {
        HStack {
            GradientButton(
                title: "",
                systemImageName: "house.fill",
                action: {
                    snakeModel.stopSnakeHissSound()
                    snakeModel.isMenuVisible = true
                },
                accessibilityLabel: "Выйти в главное меню"
            )
            .padding(.leading, 10)
            .fixedSize()
            
            Spacer()
            
            HStack(spacing: 20) {
                // Отображение текущего счета
                HStack {
                    Text("🍎")
                        .font(.title)
                        .foregroundColor(.red)
                        .accessibilityHidden(true)
                    Text("\(snakeModel.score)")
                        .font(.title)
                        .foregroundColor(.white)
                        .accessibility(label: Text("Очки: \(snakeModel.score)"))
                }
                
                // Отображение количества шагов за свайп, если включены функции доступности или запущен VoiceOver
                if snakeModel.isVoiceOverEnabled || UIAccessibility.isVoiceOverRunning {
                    HStack {
                        Text("👣")
                            .font(.title)
                            .foregroundColor(.blue)
                            .accessibilityHidden(true)
                        Text("\(snakeModel.stepsPerMove)")
                            .font(.title)
                            .foregroundColor(.white)
                            .accessibility(label: Text("Шаги за свайп: \(snakeModel.stepsPerMove)"))
                    }
                }
            }
            .padding(.trailing, 10)
        }
        .padding(.top, 10)
    }

    // Игровое поле с отрисовкой змейки и еды
    private var gameField: some View {
        ZStack {
            gameCanvas
            if snakeModel.isVoiceOverEnabled && UIAccessibility.isVoiceOverRunning && !snakeModel.isGameOver {
                voiceOverControls
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                if !(snakeModel.isVoiceOverEnabled && UIAccessibility.isVoiceOverRunning) {
                    withAnimation {
                        snakeModel.changeDirection(with: value)
                    }
                }
            })
    }

    // Отрисовка игрового поля
    private var gameCanvas: some View {
        Canvas { context, size in
            let fieldWidth = geometry.size.width
            let fieldHeight = geometry.size.height - 100
            let columns: Int = 30
            let rows: Int = 60
            let cellWidth = fieldWidth / CGFloat(columns)
            let cellHeight = fieldHeight / CGFloat(rows)

            // Отрисовка змейки
            for (index, segment) in snakeModel.snakeBody.enumerated() {
                let rect = CGRect(
                    x: CGFloat(segment.x) * cellWidth,
                    y: CGFloat(segment.y) * cellHeight,
                    width: cellWidth,
                    height: cellHeight
                )

                if index == 0 {
                    drawSnakeHead(context: context, rect: rect, direction: snakeModel.currentDirection)
                } else {
                    let path = Path(roundedRect: rect, cornerRadius: min(cellWidth, cellHeight) / 4)
                    context.fill(path, with: .color(Color.darkGreen))
                }
            }

            // Отрисовка еды
            if let food = snakeModel.foodPosition {
                let foodSize = CGSize(width: cellWidth + 2, height: cellHeight + 2)
                let foodRect = CGRect(
                    x: CGFloat(food.x) * cellWidth,
                    y: CGFloat(food.y) * cellHeight,
                    width: foodSize.width,
                    height: foodSize.height
                )

                let foodEmoji = Text("🍎")
                    .font(.system(size: min(foodSize.width, foodSize.height)))
                context.draw(foodEmoji, at: CGPoint(x: foodRect.midX, y: foodRect.midY))
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height - 100)
        .border(Color.white, width: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Игровое поле змейки")
    }

    // Кнопки управления для пользователей VoiceOver
    @ViewBuilder
    private var voiceOverControls: some View {
        VStack {
            HStack {
                // Кнопка "Влево"
                directionButton(direction: .left, systemImageName: "arrow.left.circle.fill")
                Spacer()
                // Кнопка "Вправо"
                directionButton(direction: .right, systemImageName: "arrow.right.circle.fill")
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)

            Spacer()

            HStack {
                // Кнопка "Вверх"
                directionButton(direction: .up, systemImageName: "arrow.up.circle.fill")
                Spacer()
                // Кнопка "Вниз"
                directionButton(direction: .down, systemImageName: "arrow.down.circle.fill")
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
    }

    // Общий метод для создания кнопки направления
    private func directionButton(direction: SnakeModel.Direction, systemImageName: String) -> some View {
        GradientButton(
            title: "",
            systemImageName: systemImageName,
            action: {
                snakeModel.changeDirectionWithVoiceOver(direction: direction)
            },
            accessibilityLabel: "Двигаться \(direction.accessibilityDescription)"
        )
        .opacity(0.25)
    }

    // Экран "Game Over"
    private var gameOverScreen: some View {
        Color.black.opacity(0.75)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    TitleTextWithBackground(text: "Game Over")

                    GradientButton(
                        title: "Начать заново",
                        systemImageName: "arrow.counterclockwise",
                        action: {
                            snakeModel.resetGame()
                        },
                        accessibilityLabel: "Начать заново"
                    )
                    .padding()

                    GradientButton(
                        title: "Выйти в главное меню",
                        systemImageName: "house.fill",
                        action: {
                            snakeModel.stopSnakeHissSound()
                            snakeModel.isMenuVisible = true
                        },
                        accessibilityLabel: "Выйти в главное меню"
                    )
                    .padding()
                }
            )
            .onAppear {
                snakeModel.playGameOverSound()
            }
    }

    // Отрисовка головы змейки
    private func drawSnakeHead(context: GraphicsContext, rect: CGRect, direction: SnakeModel.Direction) {
        let headPath = Path(roundedRect: rect, cornerRadius: min(rect.width, rect.height) / 4)
        context.fill(headPath, with: .color(Color.darkGreen))

        let eyeSize = CGSize(width: rect.width * 0.2, height: rect.height * 0.2)
        let (leftEyeRect, rightEyeRect) = getEyeRects(rect: rect, direction: direction, eyeSize: eyeSize)
        context.fill(Path(ellipseIn: leftEyeRect), with: .color(.white))
        context.fill(Path(ellipseIn: rightEyeRect), with: .color(.white))

        // Отрисовка языка змейки
        drawSnakeTongue(context: context, rect: rect, direction: direction)
    }

    // Получение координат для глаз змейки
    private func getEyeRects(rect: CGRect, direction: SnakeModel.Direction, eyeSize: CGSize) -> (CGRect, CGRect) {
        let eyeOffsetX: CGFloat
        let eyeOffsetY: CGFloat

        switch direction {
        case .up:
            eyeOffsetX = rect.width * 0.25
            eyeOffsetY = rect.height * 0.1
        case .down:
            eyeOffsetX = rect.width * 0.25
            eyeOffsetY = rect.height * 0.7
        case .left:
            eyeOffsetX = rect.width * 0.1
            eyeOffsetY = rect.height * 0.25
        case .right:
            eyeOffsetX = rect.width * 0.7
            eyeOffsetY = rect.height * 0.25
        }

        let eyeShift = (direction == .left || direction == .right) ? rect.width * 0.05 : rect.height * 0.05

        let leftEyeRect = CGRect(
            x: rect.minX + eyeOffsetX - eyeShift,
            y: rect.minY + eyeOffsetY - eyeShift,
            width: eyeSize.width,
            height: eyeSize.height
        )
        let rightEyeRect = CGRect(
            x: rect.minX + (rect.width - eyeOffsetX - eyeSize.width) + eyeShift,
            y: rect.minY + eyeOffsetY - eyeShift,
            width: eyeSize.width,
            height: eyeSize.height
        )

        return (leftEyeRect, rightEyeRect)
    }

    // Отрисовка языка змейки
    private func drawSnakeTongue(context: GraphicsContext, rect: CGRect, direction: SnakeModel.Direction) {
        let tongueWidth = rect.width * 0.2
        let tongueHeight = rect.height * 0.4

        let (tongueStartX, tongueStartY, tongueEndX, tongueEndY) = getTongueCoordinates(
            direction: direction,
            rect: rect,
            tongueHeight: tongueHeight,
            tongueWidth: tongueWidth
        )

        let tonguePath = Path { path in
            path.move(to: CGPoint(x: tongueStartX, y: tongueStartY))
            path.addLine(to: CGPoint(x: tongueEndX, y: tongueEndY - tongueWidth / 2))
            path.addLine(to: CGPoint(x: tongueEndX, y: tongueEndY + tongueWidth / 2))
            path.closeSubpath()
        }

        context.fill(tonguePath, with: .color(.red))
    }

    // Получение координат для языка змейки
    private func getTongueCoordinates(direction: SnakeModel.Direction, rect: CGRect, tongueHeight: CGFloat, tongueWidth: CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch direction {
        case .up:
            return (rect.midX, rect.minY, rect.midX, rect.minY - tongueHeight)
        case .down:
            return (rect.midX, rect.maxY, rect.midX, rect.maxY + tongueHeight)
        case .left:
            return (rect.minX, rect.midY, rect.minX - tongueWidth, rect.midY)
        case .right:
            return (rect.maxX, rect.midY, rect.maxX + tongueWidth, rect.midY)
        }
    }
}

// Расширение для доступа к описанию направления
extension SnakeModel.Direction {
    var accessibilityDescription: String {
        switch self {
        case .up: return "вверх"
        case .down: return "вниз"
        case .left: return "влево"
        case .right: return "вправо"
        }
    }
}

// Предварительный просмотр GameView
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            GameView(snakeModel: SnakeModel(), geometry: geometry)
        }
    }
}
