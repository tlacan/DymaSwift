//
//  NetworkTypes+Helpers.swift
//  TripManager
//
//  Created by thomas lacan on 01/08/2024.
//

import Foundation

public enum Server: String {
  case dev = "http://localhost:80/"
}

public typealias APIResponse<T: Decodable> = Result<T, APIError>

extension Data {
  func mapJSON() -> Any? {
    try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
  }
}

extension URLRequest {
  public var curlString: String {
    var result = "curl -k "

    if let method = httpMethod {
        result += "-X \(method) \\\n"
    }

    if let headers = allHTTPHeaderFields {
        for (header, value) in headers {
            result += "-H \"\(header): \(value)\" \\\n"
        }
    }

    if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
        result += "-d '\(string)' \\\n"
    }

    if let url {
        result += url.absoluteString
    }

    return result
  }

}
