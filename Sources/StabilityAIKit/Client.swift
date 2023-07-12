import Foundation

/// Configuration of the Stability AI Client
public struct Configuration {
    /// The API key used to authenticate requests.
    public var apiKey: String
    /// Used to identify the source of requests, such as the client application or sub-organization. Optional, but recommended for organizational clarity.
    public var clientId: String?
    /// Used to identify the version of the application or service making the requests. Optional, but recommended for organizational clarity.
    public var clientVersion: String?
    /// Allows for requests to be scoped to an organization other than the user's default. If not provided, the user's default organization will be used.
    public var organization: String?
    /// Server configuration
    public var api: API?
    
    public init(
        apiKey: String,
        clientId: String? = nil,
        clientVersion: String? = nil,
        organization: String? = nil,
        api: API? = nil
    ) {
        self.apiKey = apiKey
        self.clientId = clientId
        self.clientVersion = clientVersion
        self.organization = organization
        self.api = api
    }
}

public class Client {
    
    public var configuration: Configuration
    
    private var session: URLSession = .shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func prepareRequst(path: String, method: String, timeout: TimeInterval = 60) async throws -> URLRequest {
        var components = URLComponents()
        components.scheme = configuration.api?.scheme.value ?? API.Scheme.https.value
        components.host = configuration.api?.host ?? "api.stability.ai"
        components.path = [configuration.api?.path, path].compactMap { $0 }.joined()
        guard let url = components.url else { throw StabilityError.invalidURLGenerated }
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.addValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
        configuration.organization.map { request.addValue($0, forHTTPHeaderField: "Organization") }
        configuration.clientId.map { request.addValue($0, forHTTPHeaderField: "Stability-Client-ID") }
        configuration.clientVersion.map { request.addValue($0, forHTTPHeaderField: "Stability-Client-Version") }
        request.httpMethod = method
        return request
    }
    
    func validateResponse(data: Data, response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else { throw StabilityError.invalidResponse }
        if response.statusCode == 200 { return }
        if let error = try? decoder.decode(StabilityAPIError.self, from: data) {
            throw StabilityError.errorResponse(error.message)
        } else {
            throw StabilityError.errorResponse("Invalid response status code: \(response.statusCode)")
        }
    }
    
    /// Get information about the account associated with the provided API key
    /// - Returns: Account information
    public func getAccount() async throws -> Account {
        var urlRequest = try await prepareRequst(path: "/v1/user/account", method: "GET")
        let (data, response) = try await session.data(for: urlRequest)
        try validateResponse(data: data, response: response)
        return try decoder.decode(Account.self, from: data)
    }
    
    /// Get the credit balance of the account/organization associated with the API key
    /// - Returns: Balance information
    public func getBalance() async throws -> Balance {
        var urlRequest = try await prepareRequst(path: "/v1/user/balance", method: "GET")
        let (data, response) = try await session.data(for: urlRequest)
        try validateResponse(data: data, response: response)
        return try decoder.decode(Balance.self, from: data)
    }
    
    /// Get a list of available engines
    /// - Returns: List of engines
    public func getEngines() async throws -> [Engine] {
        let request = try await prepareRequst(path: "/v1/engines/list", method: "GET")
        let (data, response) = try await session.data(for: request)
        try validateResponse(data: data, response: response)
        return try decoder.decode([Engine].self, from: data)
    }
    
    /// Makes text to image request
    /// - Parameters:
    ///   - request: Text to image properties
    ///   - engine: Engine id
    /// - Returns: Array of results
    public func getImageFromText(_ request: TextToImageRequest, engine: String) async throws -> [ImageResponse] {
        var urlRequest = try await prepareRequst(path: "/v1/generation/\(engine)/text-to-image",
                                                 method: "POST",
                                                 timeout: .infinity)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try encoder.encode(request)
        let (data, response) = try await session.data(for: urlRequest)
        try validateResponse(data: data, response: response)
        return try decoder.decode(StabilityResponse.self, from: data).artifacts
    }
    
    /// Makes image to image request
    /// - Parameters:
    ///   - request: Image to image properties
    ///   - engine: Engine id
    /// - Returns: Array of results
    public func getImageFromImage(_ request: ImageToImageRequest, engine: String) async throws -> [ImageResponse] {
        var urlRequest = try await prepareRequst(path: "/v1/generation/\(engine)/image-to-image",
                                                 method: "POST",
                                                 timeout: .infinity)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try request.createMultipartBody(boundary: boundary)
        let (data, response) = try await session.data(for: urlRequest)
        try validateResponse(data: data, response: response)
        return try decoder.decode(StabilityResponse.self, from: data).artifacts
    }
}
