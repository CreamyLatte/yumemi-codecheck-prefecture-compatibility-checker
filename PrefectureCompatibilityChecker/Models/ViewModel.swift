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
    func checkCompatibility(person: Person) async throws -> FortuneResult {
        return try await prefectureCompatibilityChecker.checkCompatibility(person: person)
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
