//
//  CardView.swift
//  FlashZilla
//
//  Created by Zaheer Moola on 2021/08/11.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil

    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    @State private var feedback = UINotificationFeedbackGenerator()

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                        ? Color.white
                        : Color.white
                        .opacity(1 - Double(abs(offset.width / 50)))

                )
                .background(
                    differentiateWithoutColor
                        ? nil
                        : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(getBackgroundColor(offset: offset))
                )
                .shadow(radius: 10)

            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibility(addTraits: .isButton)
        .gesture(DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        feedback.prepare()
                    }
                    .onEnded { _ in
                        if abs(offset.width) > 100 {
                            if offset.width > 0 {
                                feedback.notificationOccurred(.success)
                                removal?(false)
                            } else {
                                feedback.notificationOccurred(.error)
                                removal?(true)
                            }

                        } else {
                            offset = .zero
                        }
                    })
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring())
    }

    func getBackgroundColor(offset: CGSize) -> Color {
            if offset.width > 0 {
                return .green
            }

            if offset.width < 0 {
                return .red
            }

            return .white
        }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
