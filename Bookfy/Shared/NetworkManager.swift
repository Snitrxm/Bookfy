import Foundation
import UniformTypeIdentifiers
import UIKit

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case noData
}

extension NetworkError {
    func getErrorMessage() -> String {
        switch self {
        case .requestFailed(let nsError as NSError):
            return nsError.localizedDescription
        case .invalidURL:
            return "URL inválida."
        case .noData:
            return "Nenhum dado recebido do servidor."
        case .decodingFailed:
            return "Falha ao decodificar a resposta do servidor."
        }
    }
}

class NetworkManager {
    let baseURL = "https://openlibrary.org/search.json"
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 299 {
                if let data = data {
                    if let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let errorMessage = jsonError["message"] as? String {
                        let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(.requestFailed(backendError)))
                    } else if let errorMessage = String(data: data, encoding: .utf8) {
                        let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(.requestFailed(backendError)))
                    } else {
                        let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"])
                        completion(.failure(.requestFailed(genericError)))
                    }
                } else {
                    completion(.failure(.noData))
                }
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }

        task.resume()
    }

    func request(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        bearerToken: String? = nil,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 299 {
                if let data = data {
                    if let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let errorMessage = jsonError["message"] as? String {
                        let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(.requestFailed(backendError)))
                        } else if let errorMessage = String(data: data, encoding: .utf8) {
                            let backendError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(.requestFailed(backendError)))
                        } else {
                            let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"])
                            completion(.failure(.requestFailed(genericError)))
                        }
                } else {
                    completion(.failure(.noData))
                }
                return
            }

            completion(.success(()))
        }

        task.resume()
    }
}

