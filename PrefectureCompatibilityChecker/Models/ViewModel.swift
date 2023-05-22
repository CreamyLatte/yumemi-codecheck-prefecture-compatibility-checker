//
//  ViewModel.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/22.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    @Published var isInput: Bool = false
    @Published var isResult: Bool = false
    
    let prefectureCompatibilityChecker = PrefectureCompatibilityChecker()
    func checkCompatibility(person: Person) async -> FortuneResult? {
        let fortuneResult: FortuneResult
        do {
            fortuneResult = try await prefectureCompatibilityChecker.checkCompatibility(person: person)
        } catch {
            print("Couldn't tell a fortune. \(error)")
            return nil
        }
        return fortuneResult
    }
    
    func showInputView() {
        isInput = true
    }
    func showResultView() {
        isResult = true
    }
    func showMainView() {
        isInput = false
        isResult = false
    }
}
