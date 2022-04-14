//
//  ContentView.swift
//  AnimationSandbox
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

struct AnimatingCircleContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Text("Click Me")
            .onTapGesture {
                animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding(100)
            .scaleEffect(animationAmount)
            .blur(radius: (animationAmount - 1) * 3)
            .animation(
                .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: animationAmount
            )
    }
}

struct PulsatingCircleContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Text("Click Me")
            .onTapGesture {
                // animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            .padding(100)
            .onAppear {
                animationAmount = 2
            }
    }
}

struct AnimatedBindingsContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        print(animationAmount)

        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)

            Text("Click Me")
                .onTapGesture {
                    animationAmount += 1
                }
                .padding(40)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding(100)
                .scaleEffect(animationAmount)
        }
    }
}

struct SpinningCircleContentView: View {
    @State private var animationAmount = 0.0

    var body: some View {
        Text("Click Me")
            .onTapGesture {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    animationAmount += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding(100)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct AnimationStackContentView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false

    var body: some View {
        Text("Click Me")
            .onTapGesture {
                enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            .animation(nil, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
    }
}

struct DraggableCardContentView: View {
    @State private var dragAmount = CGSize.zero

    var body: some View {
        Color.red
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(200)
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragAmount = .zero
                        }
                    }
            )
    }
}

struct SnakingLettersContentView: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
        .padding(200)
    }
}

struct TransitionsContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Click Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
