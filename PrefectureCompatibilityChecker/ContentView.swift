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
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("47都道府県\n相性マッチング")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                Button(action: {
                    viewModel.showInputView()
                }, label: {
                    Text("占う")
                })
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isInput) {
                PersonInputView()
            }
            
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
