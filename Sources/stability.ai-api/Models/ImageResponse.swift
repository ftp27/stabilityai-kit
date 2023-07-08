import Foundation

public struct ImageResponse: Codable {
    /// Image encoded in base64
    var base64: String
    var finishReason: FinishReason
    /// The seed associated with this image
    var seed: Int
}

public enum FinishReason: String, Codable {
    case contentFiltered = "CONTENT_FILTERED"
    case error = "ERROR"
    case success = "SUCCESS"
}
