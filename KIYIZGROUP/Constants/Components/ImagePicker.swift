//  PhotoPickerVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 2/2/24.

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onSelected: (UIImage?, String?) -> Void
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            let imageURL = info[.imageURL] as? URL
            let fileName = imageURL?.lastPathComponent
            
            parent.selectedImage = image
            parent.isPresented = false
            parent.onSelected(image, fileName)
        }
    }
}


struct PhotoSourceSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    @Binding var isShowGallery: Bool
    @Binding var isShowCamera: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 16) {
                    textComponent.createText(text: "Выберите источник фото", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                    CustomDivider()
                    Button(action: {
                        isShowGallery = true
                        onDismiss()
                    }) {
                        textComponent.createText(text: "Галерея", fontSize: 16, fontWeight: .regular,lightColor: .black, darkColor: .white)
                            .frame(maxWidth: .infinity)
                    }
                    CustomDivider()
                    Button(action: {
                        isShowCamera = true
                        onDismiss()
                    }) {
                        textComponent.createText(text: "Камера", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                            .frame(maxWidth: .infinity)
                    }
                    CustomDivider()
                    Button(action: {
                        onDismiss()
                    }) {
                        textComponent.createText(text: "Отмена", fontSize: 16, fontWeight: .regular, lightColor: .gray, darkColor: .white)
                    }
                }
                .padding()
            }
            .padding(.top, 16)
            .offset(y: -40)
        }
        .frame(height: 250)
        .transition(.move(edge: .bottom))
    }
}

