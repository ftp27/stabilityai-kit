import Foundation

public struct Engine: Codable {
    public var description: String
    /// Unique identifier for the engine
    public var id: String
    /// Name of the engine
    public var name: String
    /// The type of content this engine produces
    public var type: EngineType
}

public enum EngineType: String, Codable {
    case audio = "AUDIO"
    case classification = "CLASSIFICATION"
    case picture = "PICTURE"
    case storage = "STORAGE"
    case text = "TEXT"
    case video = "VIDEO"
}
