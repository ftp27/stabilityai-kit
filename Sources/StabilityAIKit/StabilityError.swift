import Foundation

public enum StabilityError: Error {
    /// The Data could not be converted to the String type.
    case cantConvertData
    /// The response is not a HTTPURLResponse.
    case invalidResponse
    /// The response status code is not 200.
    case errorResponse(String)
    /// The URL could not be generated.
    case invalidURLGenerated
}
