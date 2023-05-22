//
//  PersonInputView.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/21.
//

import SwiftUI

enum BloodType: String, CaseIterable, Identifiable {
    case a
    case b
    case ab
    case o
    
    var id: String { rawValue }
}

struct PersonInputView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var person: Person = Person()
    @State private var fortuneResult: FortuneResult? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("ニックネーム").bold()
                Divider().frame(height: 20)
                TextField("名前", text: $person.name)
                    .frame(alignment: .trailing)
            }
            DatePicker("誕生日", selection: $person.birthday, displayedComponents: .date)
                .bold()
            VStack(alignment: .leading) {
                Text("血液型").bold()
                Picker("血液型", selection: $person.bloodType) {
                    ForEach(BloodType.allCases) { type in
                        Text(type.rawValue.uppercased()).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            Button(action: {
                predict()
            }, label: {
                Text("占う")
            })
        }
        .navigationDestination(isPresented: $viewModel.isResult) {
            if let fortuneResult = fortuneResult {
                ResultView(fortuneResult: fortuneResult)
            } else {
                Text("nondata.")
            }
        }
    }
    
    func predict() {
        Task {
            self.fortuneResult = await viewModel.checkCompatibility(person: person)
        }
        viewModel.showResultView()
    }
}

struct PersonInputView_Previews: PreviewProvider {
    @StateObject static var viewModel = ViewModel()
    static var previews: some View {
        PersonInputView()
            .environmentObject(viewModel)
    }
}
