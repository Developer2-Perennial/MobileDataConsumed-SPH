//
//  APIError.swift
//  Mobile Data Usage
//
//  Created by Pere Dev on 19/04/20.
//  Copyright © 2020 Perennial Sys. All rights reserved.
//

import Alamofire
import Foundation

/// API error model to represent the API error.
public struct APIError: Swift.Error {
    
    /// It represents parse failure info.
    var parseError: ParseError?
    
    /// It represents error
    var error: Error?
    
    /// Other data
    var data: Data?
    
    var internetNotAvailble = false
}

public struct ParseError: Swift.Error {
    public let error: Error?
    public let file: String
    public let line: Int
    public let function: String
    
    /// Initialiser
    /// - Parameters:
    ///   - error: Error model
    ///   - file: File in which it occured.
    ///   - line: Line number at which error was triggered.
    ///   - function: Function name at which error was triggered.
    public init(_ error: Error?, file: String = #file, line: Int = #line, function: String = #function) {
        self.error = error
        self.file = file
        self.line = line
        self.function = function
    }
}

