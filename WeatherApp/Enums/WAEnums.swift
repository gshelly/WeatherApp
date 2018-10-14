//
//  WAEnums.swift
//  Weather
//
//  Created by shelly.gupta on 9/12/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import Foundation

enum WACustomError: Error {
    case localError(String)
}
extension WACustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .localError(let errorMessage):
            return  errorMessage
        }
    }
}
