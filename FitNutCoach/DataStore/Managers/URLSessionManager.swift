//
//  URLSessionManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//


import Foundation
import Combine

/// Simple HTTP method enum
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put  = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Network errors we surface through the publisher
public enum NetworkError: Error {
    case invalidURL(String)
    case requestFailed(statusCode: Int, data: Data?)
    case urlError(URLError)
    case decodingError(Error)
    case encodingError(Error)
    case unknown(Error)
}

/// A tiny wrapper to encode `Encodable` existential values
public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

/// Generic URLSession manager returning Combine publishers.
public final class URLSessionManager {
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared,
                encoder: JSONEncoder = JSONEncoder(),
                decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Generic request function.
    /// - Parameters:
    ///   - urlString: target URL as string
    ///   - method: HTTP method
    ///   - headers: additional headers
    ///   - queryItems: URL query items
    ///   - body: optional Encodable body (can be any Encodable)
    /// - Returns: AnyPublisher<T, NetworkError>
    public func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil,
        timeout: TimeInterval = 60
    ) -> AnyPublisher<T, NetworkError> {
        // Build URL
        guard var components = URLComponents(string: urlString) else {
            return Fail(error: NetworkError.invalidURL(urlString)).eraseToAnyPublisher()
        }

        if let q = queryItems, !q.isEmpty {
            components.queryItems = (components.queryItems ?? []) + q
        }

        guard let url = components.url else {
            return Fail(error: NetworkError.invalidURL(urlString)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.rawValue

        // Default JSON content-type for body-carrying requests
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        // Add user-supplied headers
        headers?.forEach { key, value in request.setValue(value, forHTTPHeaderField: key) }

        // Encode body if provided
        if let b = body {
            do {
                let anyEncodable = AnyEncodable(b)
                request.httpBody = try encoder.encode(anyEncodable)
            } catch {
                return Fail(error: NetworkError.encodingError(error)).eraseToAnyPublisher()
            }
        }

        // Use dataTaskPublisher and convert errors
        return session
            .dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
                }
                let code = response.statusCode
                guard (200...299).contains(code) else {
                    throw NetworkError.requestFailed(statusCode: code, data: output.data)
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { err -> NetworkError in
                // If it's already NetworkError, pass through
                if let net = err as? NetworkError { return net }
                // URL errors
                if let urlErr = err as? URLError { return .urlError(urlErr) }
                // Decoding errors
                if let dec = err as? DecodingError { return .decodingError(dec) }
                // Other errors
                return .unknown(err)
            }
            .eraseToAnyPublisher()
    }
}
