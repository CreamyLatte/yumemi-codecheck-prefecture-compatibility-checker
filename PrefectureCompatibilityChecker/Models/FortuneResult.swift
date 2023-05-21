//
//  FortuneResult.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import Foundation

struct FortuneResult: Decodable {
    let prefecture: String
    let capital: String
    let citizenDay: MonthDay?
    let hasCoastLine: Bool
    private let logoURL: String
    var prefectureImageURL: URL? {
        return URL(string: logoURL)
    }
    let brief: String
    
    struct MonthDay: Decodable {
        let month: Int
        let day: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case prefecture = "name"
        case capital
        case citizenDay = "citizen_day"
        case hasCoastLine = "has_coast_line"
        case logoURL = "logo_url"
        case brief
    }
}

extension FortuneResult.MonthDay: CustomStringConvertible {
    var description: String {
        return "\(month)月\(day)日"
    }
}
