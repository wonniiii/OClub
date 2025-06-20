//
//  WriteBottomSheet.swift
//  O'Club
//
//  Created by 최효원 on 4/11/25.
//

import SwiftUI
import PhotosUI

struct WritePostSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WriteBottomSheetViewModel
    
    init(clubID: String) {
        _viewModel = StateObject(wrappedValue: WriteBottomSheetViewModel(clubID: clubID))
    }
    
    var body: some View {
        VStack {
            headerView
            if let image = viewModel.selectedImage {
                imagePreview(image: image)
            }
            Spacer().frame(height: 28)
            titleTextField
            Spacer().frame(height: 20)
            contentTextEditor
            Spacer()
        }
        .background(Color.allBackground.ignoresSafeArea())
    }
}

private extension WritePostSheet {
    var headerView: some View {
        ZStack {
            Text("게시글 작성")
                .font(.PBody)
                .foregroundStyle(.black)
            HStack {
                PhotosPicker(
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "paperclip")
                        .font(.PBody)
                }

                Spacer()
                Button("게시하기") {
                    viewModel.uploadPost { success in
                        if success {
                            dismiss()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.1)),
            alignment: .bottom
        )
    }
    
    func imagePreview(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 200)
            .cornerRadius(8)
            .padding()
    }
    
    var titleTextField: some View {
        TextField("제목을 입력해주세요", text: $viewModel.postTitle)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal)
    }
    
    var contentTextEditor: some View {
        TextEditor(text: $viewModel.postContent)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal)
    }
}
