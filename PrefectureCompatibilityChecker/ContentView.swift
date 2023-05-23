//
//  ContentView.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                VStack {
                    TitleView()
                        .padding()
                    Button(action: {
                        viewModel.showInputView()
                    }, label: {
                        Text("自分と合う都道府県を占う")
                            .multilineTextAlignment(.center)
                    })
                    .buttonStyle(CapsuleButtonStyle())
                    .padding()
                }
                .padding()
                .navigationDestination(isPresented: $viewModel.isInput) {
                    PersonInputView()
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var viewModel = ViewModel()
    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
    }
}
