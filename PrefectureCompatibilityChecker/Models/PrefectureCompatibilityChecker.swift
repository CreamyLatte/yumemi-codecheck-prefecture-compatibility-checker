//
//  PrefectureCompatibilityChecker.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/19.
//

import Foundation

enum APIError: Error {
    case failedToCreateURL
    case failedToJSONEncode
    case failedtoURLSession
    case httpResponseError(Int, String)
    case dataError
}

class PrefectureCompatibilityChecker {
    let baseURL = "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud"
    let endPoint = "/my_fortune"
    let apiVersion = "v1"
    
    func checkCompatibility(request: Request) async throws -> FortuneResult {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endPoint) else {
            throw APIError.failedToCreateURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiVersion, forHTTPHeaderField: "API-Version")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(request)
        urlRequest.httpBody = jsonData
        
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.failedtoURLSession
        }
        
        guard httpResponse.statusCode == 200 else {
            let statusCode = httpResponse.statusCode
            let responseMessage = String(data: data, encoding: .utf8)
            let errorMessage = responseMessage ?? "no message."
            throw APIError.httpResponseError(statusCode, errorMessage)
        }
        
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(FortuneResult.self, from: data)
        
        return result
    }
    
    struct Request: Encodable {
        var name: String
        var birthday: DateStruct
        var bloodType: String
        var today: DateStruct = DateStruct.today
        
        enum CodingKeys: String, CodingKey {
            case name
            case birthday
            case bloodType = "blood_type"
            case today
        }
    }
}

extension PrefectureCompatibilityChecker.Request {
    init(person: Person) {
        self.name = person.name
        self.birthday = person.birthday
        self.bloodType = person.bloodType
    }
}

extension PrefectureCompatibilityChecker {
    func checkCompatibility(person: Person) async throws -> FortuneResult {
        let request = Request(person: person)
        return try await checkCompatibility(request: request)
    }
}

// test
let testPerson = Person(name: "John Doe", birthday: DateStruct(year: 2020, month: 4, day: 23), bloodType: "a")
let checker = PrefectureCompatibilityChecker()


