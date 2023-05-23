//
//  TitleView.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        ZStack {
            Image("japan")
                .resizable()
                .scaledToFit()
                .frame(width: 320)
                .blur(radius: 2.0)
            VStack(spacing: 20) {
                Text("あなたに合う")
                    .font(.title2)
                Text("47都道府県\n相性マッチング")
                    .font(.title)
            }
            .bold()
            .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
