//
//  AppError.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/19/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
