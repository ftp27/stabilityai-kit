import Foundation

/// Represents an account.
public struct Account: Codable {
    /// The email associated with the account.
    public var email: String
    /// The unique identifier of the account.
    public var id: String
    /// The organizations associated with the account.
    public var organizations: [Organization]
    /// The URL of the account's profile picture.
    public var profile_picture: URL?
}

/// Represents an organization.
public struct Organization: Codable {
    /// The unique identifier of the organization.
    public var id: String
    /// The name of the organization.
    public var name: String
    /// The role of the account within the organization.
    public var role: String
    /// Indicates if the organization is the default organization for the account.
    public var is_default: Bool
}

/// Represents a balance.
public struct Balance: Codable {
    /// The amount of credits in the balance.
    public var credits: Float
}
