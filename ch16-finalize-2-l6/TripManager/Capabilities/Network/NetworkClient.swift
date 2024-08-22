//
//  NetworkClient.swift
//  TripManager
//
//  Created by thomas lacan on 02/08/2024.
//

import Foundation

final class NetworkClient {
  static var defaultEncoder: JSONEncoder {
    let result = JSONEncoder()
    result.dateEncodingStrategy = .iso8601
    result.keyEncodingStrategy = .convertToSnakeCase
    return result
  }

  static var defaultDecoder: JSONDecoder {
    let result = JSONDecoder()
    result.dateDecodingStrategy = .iso8601
    result.keyDecodingStrategy = .convertFromSnakeCase
    return result
  }

  static var defaultHeaders: [String: String] = [
    "content-type": "application/json",
    "Accept": "application/json"
  ]

  let endpointMapperClass: EndpointMapper.Type
  let server: Server

  init(server: Server, endpointMapperClass: EndpointMapper.Type = TripManagerEndpointMapper.self) {
    self.endpointMapperClass = endpointMapperClass
    self.server = server
  }

  static func encodedDict(_ value: Encodable) -> [String: Any?]? {
    guard let data = try? NetworkClient.defaultEncoder.encode(value) else {
      return nil
    }
    return try? JSONSerialization.jsonObject(with: data) as? [String: Any?]
  }

  static func logRequest(request: URLRequest, urlResponse: HTTPURLResponse, data: Data) {
    print(
      """
      [NETWORK CLIENT]
      \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? ""),
      headers: \(request.allHTTPHeaderFields?.description ?? "[]]"),
      payload: \(request.httpBody?.mapJSON() ?? "[]")
      curlRequest: \(request.curlString)
      --> Response \(urlResponse.statusCode) \(urlResponse.description)
      Response Data \(data.mapJSON() ?? "[]")
      """
    )
  }

  static func urlFor(url: URL, urlDict: [String: Any?]) -> URL {
    var urlComponents = URLComponents(string: url.absoluteString)
    let queryItems = urlDict.flatMap({ (key, value) -> [URLQueryItem] in
      if let value = value as? [String] {
        return value.compactMap({ string -> URLQueryItem? in
          URLQueryItem(name: key, value: string)
        })
      }
      return [URLQueryItem(name: key, value: "\(value ?? "")")]
    })
    urlComponents?.queryItems = queryItems
    return urlComponents?.url ?? url
  }

  func url(endPoint: APIEndPoint) -> URL? {
    URL(string: server.rawValue + endpointMapperClass.path(for: endPoint))
  }

  func call<T: Decodable>(endPoint: APIEndPoint,
                          dict: [String: Any?]? = nil,
                          urlDict: [String: Any?]? = nil,
                          additionalHeaders: [String: String]? = nil,
                          timeout: TimeInterval = 60) async -> APIResponse<T> {
    guard var url = url(endPoint: endPoint) else {
      return .failure(.urlError)
    }
    if let urlDict {
      url = NetworkClient.urlFor(url: url, urlDict: urlDict)
    }
    var request = URLRequest(url: url)
    request.httpMethod = endpointMapperClass.method(for: endPoint).rawValue
    request.httpBody = dict != nil ? try? JSONSerialization.data(withJSONObject: dict ?? [:]) : nil
    request.timeoutInterval = timeout
    request.allHTTPHeaderFields = NetworkClient.defaultHeaders.merging(additionalHeaders ?? [:],
                                                                       uniquingKeysWith: { _, new in new })
    return await call(request: request)
  }

  func call<T: Decodable>(request: URLRequest) async -> APIResponse<T> {
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse else {
        return .failure(APIError.unknownError)
      }
      NetworkClient.logRequest(request: request, urlResponse: httpResponse, data: data)
      if (200...299).contains(httpResponse.statusCode) {
        do {
          let decodedObject = try NetworkClient.defaultDecoder.decode(T.self, from: data)
          return .success(decodedObject)
        } catch let error {
          return .failure(.decodingError(decodingError: error))
        }
      }
      return .failure(.serverError(statusCode: httpResponse.statusCode))
    } catch let error {
      return .failure(.other(error: error))
    }
  }

  @discardableResult
  func call<T>(endPoint: APIEndPoint,
               onDone: @escaping (APIResponse<T>) -> Void,
               dict: [String: Any?]? = nil,
               urlDict: [String: Any?]? = nil,
               additionalHeaders: [String: String]? = nil,
               timeout: TimeInterval = 60) -> URLSessionDataTask? {
      guard var url = url(endPoint: endPoint) else {
        onDone(.failure(APIError.urlError))
        return nil
      }
      if let urlDict {
        url = NetworkClient.urlFor(url: url, urlDict: urlDict)
      }

      var request = URLRequest(url: url)
      request.httpMethod = endpointMapperClass.method(for: endPoint).rawValue
      request.httpBody = dict != nil ? try? JSONSerialization.data(withJSONObject: dict ?? [:], options: []) : nil
      request.timeoutInterval = timeout
      request.allHTTPHeaderFields = NetworkClient.defaultHeaders.merging(additionalHeaders ?? [:]) { _, new in new }

      return call(request: request, onDone: onDone)
    }

    @discardableResult
    func call<T: Decodable>(request: URLRequest,
                            onDone: @escaping (APIResponse<T>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
              onDone(.failure(APIError.other(error: error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                onDone(.failure(APIError.unknownError))
                return
            }

            NetworkClient.logRequest(request: request, urlResponse: httpResponse, data: data)

            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decodedObject = try NetworkClient.defaultDecoder.decode(T.self, from: data)
                    onDone(.success(decodedObject))
                } catch let error {
                    print("[DECODING ERROR] \(error.localizedDescription)")
                  onDone(.failure(.decodingError(decodingError: error)))
                }
            }
            onDone(.failure(.serverError(statusCode: httpResponse.statusCode)))
        }
        task.resume()
        return task
    }
}
