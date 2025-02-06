//  ConfirmCustomOrderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 4/2/25.

import SwiftUI

struct CustomOrderView: View {
    @ObservedObject var viewModel: CustomProductVM
    @State private var designImage: UIImage? = nil
    @State var isLoading = false


    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 8)
                
                CustomHeaderView(title: "Заказ")
                    .padding(.top, 4)
                
                OrderDetailsSection(
                    productType: viewModel.selectedProduct?.name ?? "Не выбран",
                    comment: viewModel.comment,
                    designImage: designImage
                )
                .padding(.top, 4)
                
                ContactInfoSection(phoneNumber: $viewModel.phoneNumber)
                    .padding([.horizontal, .vertical])
                
                Spacer()
                
                GreenButton(
                    text: "Оформить заказ",
                    isDisabled: viewModel.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ) {
                    Task {
                        await viewModel.submitOrder()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            }
            if viewModel.showInfoView {
                InfoView(isOpenView: $viewModel.showInfoView)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: viewModel.showInfoView)
        .padding(.horizontal, 16)
        .navigationTitle("Индивидуальный заказ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                designImage = await loadSelectedDesignImage()
            }
        }
        .navigationDestination(isPresented: $viewModel.showOrderDetails) {
            CustomDetailsView()
        }
    }
}

extension CustomOrderView {
    @MainActor
    
    private func loadSelectedDesignImage() async -> UIImage? {
        if let attachedImage = viewModel.selectedImage {
            return attachedImage // Прикрепленное пользователем изображение
        } else if let styleImageURL = viewModel.styleURLs[viewModel.selectedStyle?.id ?? 0] {
            do {
                let (data, _) = try await URLSession.shared.data(from: styleImageURL) // Асинхронная загрузка данных
                if let image = UIImage(data: data) {
                    return image
                }
            } catch {
                print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
        return nil
    }
}



struct CustomHeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    
    var title: String
    var body: some View {
        HStack{
            textComponent.createText(text: title, fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)
            Spacer()
        }
        .padding()
    }
}


struct OrderDetailsSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    var productType: String
    var comment: String
    var designImage: UIImage?
    
    
    var body: some View {
        VStack(spacing: 12) {
            VStack{
                HStack {
                    textComponent.createText(text: "Тип товара", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: productType, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                
                HStack {
                    textComponent.createText(text: "Дизайн", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    if let image = designImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
            
            
            
            VStack(alignment: .leading) {
                textComponent.createText(text: "Комментарий", fontSize: 16, fontWeight: .regular, color: .gray)
                    .padding(.vertical, 4)
                textComponent.createText(text: comment, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
    }
}




struct ContactInfoSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    private let customTextField = CustomTextField()
    
    
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Контактные данные", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
            
            textComponent.createText(text: "Оставьте свой номер телефона и наш оператор свяжется с вами в ближайшее время для уточнения деталей", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            
            customTextField.createTextField(placeholder: "+996*", text: $phoneNumber, color: colorScheme == .dark ? .white : .black, borderColor: .colorDarkBrown)
            
                .padding()
            
        }
        
    }
}


struct SubmitButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray)
                )
        }
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            TextEditor(text: $text)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .background(Color.clear)
        }
    }
}


