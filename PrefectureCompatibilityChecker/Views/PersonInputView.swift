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
    
    @State private var isPredicting: Bool = false
    @State private var isAlert: Bool = false
    @State private var apiError: APIError? = nil
    @State private var apiTask: Task<(), Never>? = nil
    
    var body: some View {
        ScrollView {
            Text("今日の47都道府県占い")
                .font(.title)
                .bold()
                .padding()
            Text("あなたのプロフィールを入力すると\n今日、あなたと相性の良い都道府県を占うことができます。")
                .padding(.horizontal)
            InputFieldView(person: $person)
                .padding()
                .disabled(isPredicting)
            Button(action: {
                predict()
            }, label: {
                Text("占う")
                    .opacity(isPredicting ? 0 : 1)
                    .overlay {
                        if isPredicting {
                            ProgressView()
                                .accentColor(.white)
                        }
                    }
            })
            .disabled(isPredicting)
            .buttonStyle(CapsuleButtonStyle())
            .padding()
        }
        .alert(Text("API接続エラー"), isPresented: $isAlert) {
            Button("OK") {
                // Handle the acknowledgement.
                apiError = nil
            }
        } message: {
            switch apiError {
            case .none:
                Text("不明なエラーです")
            case .some(let wrapped):
                Text(wrapped.errorDescription!)
            }
        }
        .onDisappear {
            apiTask?.cancel()
        }
        .navigationTitle("プロフィール入力")
        .navigationDestination(isPresented: $viewModel.isResult) {
            if let fortuneResult = fortuneResult {
                ResultView(fortuneResult: fortuneResult)
            } else {
                Text("nondata.")
            }
        }
    }
    
    func predict() {
        apiTask = Task {
            isPredicting = true
            do {
                try await Task.sleep(nanoseconds: 5 * 1000 * 1000 * 1000)
                fortuneResult = try await viewModel.checkCompatibility(person: person)
            } catch let error as APIError {
                isAlert = true
                isPredicting = false
                apiError = error
                return
            } catch {
                isAlert = true
                isPredicting = false
                return
            }
            viewModel.showResultView()
            isPredicting = false
        }
    }
}

struct PersonInputView_Previews: PreviewProvider {
    @StateObject static var viewModel = ViewModel()
    static var previews: some View {
        PersonInputView()
            .environmentObject(viewModel)
    }
}

struct InputFieldView: View {
    @Binding var person: Person
    
    var body: some View {
        VStack {
            HStack {
                Text("ニックネーム").bold()
                Divider().frame(height: 20)
                TextField("名前", text: $person.name)
            }
            Divider()
            DatePicker("誕生日", selection: $person.birthday, displayedComponents: .date)
                .bold()
            Divider()
            VStack(alignment: .leading) {
                Text("血液型").bold()
                Picker("血液型", selection: $person.bloodType) {
                    ForEach(BloodType.allCases) { type in
                        Text(type.rawValue.uppercased()).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary, lineWidth: 1))
    }
}
