//
//  MultipartFormData.swift
//  StabilityAIKit
//
//  Created by Aleksei Cherepanov on 11.07.2023.
//

import Foundation

struct MultipartFormData {
    let separator = "\r\n".data(using: .utf8)!
    let boundary: String
    private var body: Data = Data()
    
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    func getBody() -> Data {
        var body = self.body
        body.append("--\(boundary)--")
        return body
    }
    
    mutating func encode(data: Data, name: String, fileName: String, mimeType: String) {
        body.append("--\(boundary)")
        body.append(separator)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"")
        body.append(separator)
        body.append("Content-Type: \(mimeType)")
        body.append(separator)
        body.append(separator)
        body.append(data)
        body.append(separator)
    }
    
    mutating func encode(string: String, name: String) {
        body.append("--\(boundary)")
        body.append(separator)
        body.append("Content-Disposition: form-data; name=\"\(name)\"")
        body.append(separator)
        body.append(separator)
        body.append(string)
        body.append(separator)
    }
    
    mutating func encode(prompts: [TextPrompt], name: String) {
        for (offset, prompt) in prompts.enumerated() {
            let paramName = "\(name)[\(offset)]"
            encode(string: prompt.text, name: "\(paramName)[text]")
            guard let weight = prompt.weight else { continue }
            encode(string: "\(weight)", name: "\(paramName)[weight]")
        }
    }
}

private extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}
