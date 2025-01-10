//  ButtonsAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

enum ActiveScreen: Identifiable, Equatable {
    case registration
    case authorization
    
    var id: String {
        switch self {
        case .registration: return "registration"
        case .authorization: return "authorization"
        }
    }
}


struct ButtonsAuthView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    var onButtonTap: (ActiveScreen) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    onButtonTap(.registration)
                }
            }) {
                textComponent.createText(text: "Регистрация", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.colorDarkBrown, lineWidth: 1)
                    )
            }
            Button(action: {
                withAnimation {
                    onButtonTap(.authorization)
                }
            }) {
                textComponent.createText(text: "Войти", fontSize: 16, fontWeight: .regular, color: .white)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .background(Color.colorGreen)
                    .cornerRadius(40)
            }
        }
        .frame(height: 54)
        .padding([.horizontal, .vertical])
    }
}




//    var body: some View {
//        HStack(spacing: 16) {
//            NavigationLink(destination: RegistrationView(onRegistrationSuccess: onRegistrationSuccess)) {
//                textComponent.createText(text: "Регистрация", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    .frame(maxWidth: .infinity, maxHeight: 54)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 40)
//                            .stroke(Color.colorDarkBrown, lineWidth: 1)
//                    )
//            }
//            NavigationLink(destination: AuthorizationView(onAuthenticationSuccess: onAuthenticationSuccess)) {
//                textComponent.createText(text: "Войти", fontSize: 16, fontWeight: .regular, color: .white)
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, maxHeight: 54)
//                    .background(Color.colorGreen)
//                    .cornerRadius(40)
//            }
//        }
//        .frame(height: 54)
//        .padding([.horizontal,.vertical])
//    }
//}


extension View {
    func customTransition() -> some View {
        self.transition(.move(edge: .leading))
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
}


extension View {
    func customTransition(isPresented: Binding<ActiveScreen?>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(1)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.1), value: isPresented.wrappedValue)
    }
}

//    ------------
struct CustomTransitionModifier: ViewModifier {
    let isPresented: Bool
    let edge: Edge

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(isPresented ? 1 : 0)
            .offset(x: isPresented ? 0 : (edge == .leading ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
            .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}

extension View {
    func customTransition(isPresented: Bool, from edge: Edge = .trailing) -> some View {
        self.modifier(CustomTransitionModifier(isPresented: isPresented, edge: edge))
    }
}

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    static func openWebsite(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Некорректный URL")
            return
        }
        shared.open(url, options: [:], completionHandler: nil)
    }
}

