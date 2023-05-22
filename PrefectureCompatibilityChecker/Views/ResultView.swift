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
    
    var body: some View {
        VStack {
            Text(fortuneResult.prefecture).font(.title)
            AsyncImage(url: fortuneResult.prefectureImageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            PrefectureInfoView(fortuneResult: fortuneResult)
            if viewModel.isResult {
                Button(action: {
                    viewModel.showMainView()
                }, label: {
                    Text("タイトル画面に戻る")
                })
            }
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
            Text("🏢\(administrativeWord)庁所在地 \(fortuneResult.capital)")
            
            if let citizenDay = fortuneResult.citizenDay?.description {
                Text("🗓️\(administrativeWord)民の日 \(citizenDay)")
            }
            if fortuneResult.hasCoastLine {
                Text("🌊海に面した地域")
            }
            Text(fortuneResult.brief)
        }
    }
}
