//
//  NetworkError.swift
//  TheMovieDB
//
//  Created by jianli on 4/7/22.
//

import Foundation


enum NetworkError:Error{
    case badURL
    case decodeError(Error)
    case netError(Error)
    case other(Error)
}
