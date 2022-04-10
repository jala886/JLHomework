//
//  File.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import Foundation


let userNameSaveKey = "UserNameSaveKey"
let greetPrefix = "Hello:"

enum NormError:Error{
    case userNameError(String)
}

enum SegmentType:Int,CaseIterable{
    case MovieList = 0
    case Favorites
    var name:String{
        switch self{
        case .MovieList:
            return "Movie list"
        case .Favorites:
            return "Favorites"
        }
    }
    
    var position:Int{
        self.rawValue
    }
}
