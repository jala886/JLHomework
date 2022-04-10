//
//  MovieModel.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import Foundation
import UIKit

struct PageModel: Codable{
    let page:Int
    let results:[MovieModel]
}

struct MovieModel: Codable{
    let id:Int
    //let backdropPath:String?
    let posterPath:String?
    let title:String
    let overview:String
    // for internal
    var favor:Bool?
    //var posterImage:Data?
    
        enum CodingKeys:String, CodingKey{
            case id
            case posterPath = "poster_path"
            case overview
            case title
//            case favor
//            case posterImage
        }
}

struct MovieDetailModel:Codable{
    let id:Int
    let posterPath:String?
    let title:String
    let overview:String
    let productionCompanies:[ProductionCompany]
    
    enum CodingKeys:String, CodingKey{
        case id
        case posterPath = "poster_path"
        case title
        case overview
        case productionCompanies = "production_companies"
    }
}

struct ProductionCompany:Codable{
    let id:Int
    let logoPath:String?
    let name:String
    let country:String
    var logoData:Data?
    
    enum CodingKeys:String, CodingKey{
        case id
        case logoPath = "logo_path"
        case name
        case country = "origin_country"
        //case logoData
    }
}
