import Foundation

public struct StabilityClientConfig {
    /// Used to identify the source of requests, such as the client application or sub-organization. Optional, but recommended for organizational clarity.
    var clientId: String?
    /// Used to identify the version of the application or service making the requests. Optional, but recommended for organizational clarity.
    var clientVersion: String?
    /// Allows for requests to be scoped to an organization other than the user's default. If not provided, the user's default organization will be used.
    var organization: String?
    var apiKey: String
    
    var baseUrl = "https://api.stability.ai"
    var pathPrefix = ""
}

public class StabilityClient {
    
    public let config: StabilityClientConfig
    
    private var session: URLSession = .shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    public init(config: StabilityClientConfig) {
        self.config = config
    }
    
    func prepareRequst(path: String, method: String, timeout: TimeInterval = 60) async throws -> URLRequest {
        let urlString = [config.baseUrl, config.pathPrefix, path].joined(separator: "/")
        var request = URLRequest(url: URL(string: urlString)!, timeoutInterval: timeout)
        request.addValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        config.organization.map { request.addValue($0, forHTTPHeaderField: "Organization") }
        config.clientId.map { request.addValue($0, forHTTPHeaderField: "Stability-Client-ID") }
        config.clientVersion.map { request.addValue($0, forHTTPHeaderField: "Stability-Client-Version") }
        request.httpMethod = method
        return request
    }
    
    public func getEngines() async throws -> [Engine] {
        let request = try await prepareRequst(path: "v1/engines/list", method: "GET")
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw StabilityError.invalidResponse }
        guard response.statusCode == 200 else {
            throw StabilityError.errorResponse("Invalid response status code: \(response.statusCode)")
        }
        return try decoder.decode([Engine].self, from: data)
    }
    
    public func getImageFromText(_ request: TextToImageRequest, engine: String) async throws -> [ImageResponse] {
        var urlRequest = try await prepareRequst(path: "v1/generation/\(engine)/text-to-image",
                                                 method: "POST",
                                                 timeout: .infinity)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try encoder.encode(request)
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw StabilityError.invalidResponse }
        guard response.statusCode == 200 else {
            throw StabilityError.errorResponse("Invalid response status code: \(response.statusCode)")
        }
        return try decoder.decode([ImageResponse].self, from: data)
    }
    
    public func getImageFromImage(_ request: ImageToImageRequest, engine: String) async throws -> [ImageResponse] {
        var urlRequest = try await prepareRequst(path: "v1/generation/\(engine)/text-to-image",
                                                 method: "POST",
                                                 timeout: .infinity)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let boundary = "Boundary-\(UUID().uuidString)"
        let body = try request.createMultipartBody(boundary: boundary)
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body.data(using: .utf8)
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw StabilityError.invalidResponse }
        guard response.statusCode == 200 else {
            throw StabilityError.errorResponse("Invalid response status code: \(response.statusCode)")
        }
        return try decoder.decode([ImageResponse].self, from: data)
    }
}
