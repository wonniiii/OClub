//
//  ReportDetailView.swift
//  O'Club
//
//  Created by 최효원 on 4/16/25.
//

import SwiftUI
import PDFKit

struct ReportDetailView: View {
    @State private var localPDFUrl: URL?

    private let remoteURL = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!

    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationBar(
                    title: "2025년 3월 활동보고서",
                    rightButtonTitle: nil,
                    rightButtonAction: nil
                )

                if let url = localPDFUrl {
                    PDFKitView(url: url)
                        .padding()
                } else {
                    ProgressView("PDF 불러오는 중...")
                        .onAppear {
                            downloadPDF(from: remoteURL)
                        }
                }

                Spacer()
            }
        }
    }

    private func downloadPDF(from url: URL) {
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { tempUrl, _, error in
            guard let tempUrl = tempUrl, error == nil else {
                print("❌ 다운로드 실패: \(error?.localizedDescription ?? "")")
                return
            }

            let fileManager = FileManager.default
            let destination = fileManager.temporaryDirectory.appendingPathComponent("downloaded.pdf")

            try? fileManager.removeItem(at: destination)
            do {
                try fileManager.copyItem(at: tempUrl, to: destination)
                DispatchQueue.main.async {
                    self.localPDFUrl = destination
                }
            } catch {
                print("❌ PDF 이동 실패: \(error)")
            }
        }
        task.resume()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(true)
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) { }
}

#Preview {
    ReportDetailView()
}
