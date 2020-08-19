//
//  NetworkManager.swift
//  MobileDataUsage
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit
import Alamofire

public struct AppService { }

extension AppService {
    class NetworkManager : NetworkManagerService {
        func request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders, uRLEncoding: URLEncoding, completion:@escaping (Result<T, APIError>) -> Void) {
            if !checkIfInternetIsActive() {
                var apiError = APIError()
                apiError.internetNotAvailble = true
                completion(.failure(apiError))
                return
            }
            let apiUrl = MobileDataConstant.ServerBaseURL + url
            let request = AF.request(apiUrl, method: method, parameters: parameters, encoding: uRLEncoding, headers: headers).validate()

            request.responseCodable(T.self) { result in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func checkIfInternetIsActive() -> Bool {
            if !NetworkReachabilityManager()!.isReachable {
                return false
            }
            return true
        }
    }
    
}

extension Alamofire.DataRequest {
    @discardableResult
    func responseCodable<T: Decodable>(
        file: String = #file, line: Int = #line, function: String = #function,
        _ type: T.Type,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Swift.Result<T, APIError>) -> Void
    ) -> Alamofire.DataRequest {
        return self.responseData { dataResponse in
            if dataResponse.response?.statusCode == 200, let data = dataResponse.value {
                do {
                    completion(.success(try decoder.decode(type, from: data)))
                } catch {
                    let parseError = ParseError(error, file: file, line: line, function: function)
                    completion(.failure(APIError.init(parseError: parseError, error: nil, data: nil)))
                }
            } else {
                completion(.failure(APIError.init(parseError: nil, error: dataResponse.error, data: dataResponse.data)))
            }
        }
    }
}
