//
//  ResultView.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/21.
//

import SwiftUI

struct ResultView: View {
    let fortuneResult: FortuneResult
    var prefecture: String { fortuneResult.prefecture }
    var prefectureImageURL: URL? { fortuneResult.prefectureImageURL }
    
    var body: some View {
        VStack {
            Text(prefecture).font(.title)
            AsyncImage(url: prefectureImageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            PrefectureInfoView(fortuneResult: fortuneResult)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static let result: FortuneResult = load("ResultSample.json")
    static var previews: some View {
        ResultView(fortuneResult: result)
    }
}

struct PrefectureInfoView: View {
    let fortuneResult: FortuneResult
    var capital: String { fortuneResult.capital }
    var citizenDay: String? { fortuneResult.citizenDay?.description }
    var administrativeWord: String { String(fortuneResult.prefecture.last!) }
    var hasCoastLine: Bool { fortuneResult.hasCoastLine }
    var brief: String { fortuneResult.brief }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("🏢\(administrativeWord)庁所在地 \(capital)")
            
            if let citizenDay = citizenDay {
                Text("🗓️\(administrativeWord)民の日 \(citizenDay)")
            }
            if hasCoastLine {
                Text("🌊海に面した地域")
            }
            Text(brief)
        }
    }
}
