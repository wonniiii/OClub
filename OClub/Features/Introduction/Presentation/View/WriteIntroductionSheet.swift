//
//  WriteIntroductionView.swift
//  O'Club
//
//  Created by 최효원 on 4/16/25.
//

import SwiftUI
import PhotosUI

struct WriteIntroductionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WriteIntroductionSheetViewModel
    let onComplete: (String, String) -> Void

    init(club: Club, useCase: UpdateClubIntroUseCaseProtocol, onComplete: @escaping (String, String) -> Void) {
        _viewModel = StateObject(wrappedValue: WriteIntroductionSheetViewModel(club: club, useCase: useCase))
        self.onComplete = onComplete
    }

    var body: some View {
        VStack {
            headerView

            if let image = viewModel.selectedImage {
                imagePreview(image: image)
            } else {
                AsyncImage(url: URL(string: viewModel.originalImageURL)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().frame(maxHeight: 200).cornerRadius(8).padding(.horizontal)
                    } else {
                        ProgressView().frame(maxHeight: 200)
                    }
                }
            }

            Spacer().frame(height: 28)
            contentTextEditor
            Spacer()
        }
        .background(Color.allBackground.ignoresSafeArea())
    }

    private var headerView: some View {
        ZStack {
            Text("소개글 수정")
                .font(.PBody)
                .foregroundStyle(.black)
            HStack {
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "paperclip")
                        .font(.PBody)
                        .foregroundStyle(.black)
                }
                Spacer()
                Button("완료") {
                    viewModel.submit { result in
                        switch result {
                        case .success(let (desc, url)):
                            onComplete(desc, url)
                            dismiss()
                        case .failure(let error):
                            print("수정 실패: \(error)")
                        }
                    }
                }
                .font(.PBody)
                .foregroundStyle(.black)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, minHeight: 44)
        .padding(.top, 12).padding(.bottom, 6)
        .background(Color.white)
        .overlay(Rectangle().frame(height: 1).foregroundColor(.black.opacity(0.1)), alignment: .bottom)
    }

    private func imagePreview(image: UIImage) -> some View {
        Image(uiImage: image).resizable().scaledToFit().frame(maxHeight: 200).cornerRadius(8).padding(.horizontal).padding(.top, 10)
    }

    private var contentTextEditor: some View {
        TextEditor(text: $viewModel.postContent)
            .overlay(alignment: .topLeading) {
                Text("내용을 입력해주세요")
                    .foregroundStyle(viewModel.postContent.isEmpty ? Color.secondary.opacity(0.5) : .clear)
                    .font(.PCallout)
                    .padding(11)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
    }
}
