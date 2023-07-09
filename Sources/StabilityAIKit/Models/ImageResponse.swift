import Foundation

public struct ImageResponse: Codable {
    /// Image encoded in base64
    public var base64: String
    public var finishReason: FinishReason
    /// The seed associated with this image
    public var seed: Int
}

public struct StabilityResponse: Codable {
    public var artifacts: [ImageResponse]
}

public extension ImageResponse {
    public var data: Data? { Data(base64Encoded: base64) }
}

public enum FinishReason: String, Codable {
    case contentFiltered = "CONTENT_FILTERED"
    case error = "ERROR"
    case success = "SUCCESS"
}
