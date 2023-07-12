import Foundation

/// Represents an image response containing an image encoded in base64, a finish reason, and a seed value.
public struct ImageResponse: Codable {
    /// The image encoded in base64 format.
    public var base64: String
    /// The finish reason for the image response.
    public var finishReason: FinishReason
    /// The seed associated with this image.
    public var seed: Int
}

/// Represents a stability response containing an array of image artifacts.
public struct StabilityResponse: Codable {
    /// The image artifacts associated with the stability response.
    public var artifacts: [ImageResponse]
}

public extension ImageResponse {
    /// Converts the base64-encoded image to `Data` format.
    var data: Data? { Data(base64Encoded: base64) }
}

/// Represents an error that can occur in the Stability API.
public struct StabilityAPIError: Codable {
    /// The unique identifier of the error.
    var id: String
    /// The error message.
    var message: String
    /// The name of the error.
    var name: String
}

/// Enumerates the possible finish reasons for an image response.
public enum FinishReason: String, Codable {
    /// The image content has been filtered.
    case contentFiltered = "CONTENT_FILTERED"
    /// An error occurred during the image processing.
    case error = "ERROR"
    /// The image processing completed successfully.
    case success = "SUCCESS"
}
