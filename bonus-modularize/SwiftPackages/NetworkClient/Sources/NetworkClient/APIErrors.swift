//
//  APIErrors.swift
//  TripManager
//
//  Created by thomas lacan on 01/08/2024.
//

import Foundation

public enum APIError: Error, LocalizedError, Sendable {
  case urlError
  case noNetwork
  case decodingError(decodingError: Error)
  case serverError(statusCode: Int)
  case unknownError
  case other(error: Error?)

  public static func from(error: Error?) -> APIError {
    if let error = error as? APIError {
      return error
    }
    if let nsError = error as NSError?, nsError.code == NSURLErrorNotConnectedToInternet {
      return .noNetwork
    }
    return .other(error: error)
  }

  public var errorDescription: String? {
    switch self {
    case .urlError:
      return R.string.localizable.apiErrorUrlError()
    case .noNetwork:
      return R.string.localizable.apiErrorNoNetwork()
    case .decodingError(let decodingError):
      return R.string.localizable.apiErrorDecodingError(decodingError.localizedDescription)
    case .serverError(let statusCode):
      return R.string.localizable.apiErrorServerError("\(statusCode)")
    case .unknownError:
      return R.string.localizable.apiErrorUnknownError()
    case .other(let error):
      return R.string.localizable.apiErrorOther(error?.localizedDescription ?? "")
    }
  }
}
