//
//  ResultView.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/21.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var viewModel: ViewModel
    let fortuneResult: FortuneResult
    @State private var image: Image? = nil
    
    @Environment(\.colorScheme) private var colorScheme
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.clear, colorScheme == .dark ? .black : .white]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("あなたに合う都道府県は").font(.title3).bold()
                    Text(fortuneResult.prefecture).font(.title).bold()
                }
                .padding([.top, .leading, .trailing])
                
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
                    
                    ShareResultButton(
                        image: $image,
                        subject: "47都道府県占い 結果 | \(fortuneResult.prefecture)",
                        message: "私に会う都道府県は\(fortuneResult.prefecture)でした。"
                    )
                }
                
                PrefectureInfoView(fortuneResult: fortuneResult)
                    .padding(.horizontal)
                Spacer().frame(height: 100)
            }
            if viewModel.isResult {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            viewModel.showMainView()
                        }) {
                            Text("Topに戻る")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .background(gradient)
                }
            }
        }
        .task {
            await downlodImage()
        }
    }
    
    func downlodImage() async {
        guard let url = fortuneResult.prefectureImageURL else {
            return
        }
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let uiImage = UIImage(data: data)
            guard let uiImage = uiImage else { return }
            image = Image(uiImage: uiImage)
        } catch {
            return
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    @StateObject static var viewModel = ViewModel()
    static let result: FortuneResult = load("ResultSample.json")
    static var previews: some View {
        ResultView(fortuneResult: result)
            .environmentObject(viewModel)
    }
}

struct PrefectureInfoView: View {
    let fortuneResult: FortuneResult
    var administrativeWord: String { String(fortuneResult.prefecture.last!) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HeaderBodyTextView(headerText: "🏢\(administrativeWord)庁所在地", bodyText: fortuneResult.capital)
            
            if let citizenDay = fortuneResult.citizenDay?.description {
                HeaderBodyTextView(headerText: "🗓️\(administrativeWord)民の日", bodyText: citizenDay)
            }
            HeaderBodyTextView(headerText: "🗺️地域の性質", bodyText: fortuneResult.hasCoastLine ? "🌊海に面した地域" : "⛰️周りが陸地の地域")
            HeaderBodyTextView(headerText: "🔍地域の説明", bodyText: fortuneResult.brief)
        }
    }
}

struct HeaderBodyTextView: View {
    let headerText: String
    let bodyText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(headerText)
                .font(.title3)
                .bold()
            Text(bodyText)
                .padding(.leading, 20)
        }
    }
}


struct ShareResultButton: View {
    @Binding var image: Image?
    let subject: String
    let message: String
    
    var body: some View {
        if let image = image {
            ShareLink(
                item: image,
                subject: Text(subject),
                message: Text(message),
                preview: SharePreview(subject, image: image)
            ) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.accentColor)
                    .padding()
            }
        } else {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
