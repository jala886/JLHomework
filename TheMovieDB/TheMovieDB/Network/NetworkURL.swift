//
//  NetworkURL.swift
//  TheMovieDB
//
//  Created by jianli on 4/7/22.
//

import Foundation

enum ImageSize:String{
    case w92 = "w92"
    case w342 = "w342"
    case original = "original"
}
enum NetworkURL{
    case movieURL(String)
    case detailURL(String)
    case imageURL(ImageSize,String)
    
    var url:String{
        switch self{
        case .movieURL(let page):
            return "https://api.themoviedb.org/3/movie/popular?language=en-US&page=\(page)&api_key=6622998c4ceac172a976a1136b204df4"
        case .detailURL(let id):
            return "https://api.themoviedb.org/3/movie/\(id)?language=en-US&api_key=6622998c4ceac172a976a1136b204df4"
        case .imageURL(let (imageSize,posterPath)):
            return "https://image.tmdb.org/t/p/\(imageSize.rawValue)\(posterPath)"
        }
    }
}
/*
 Original is the biggest picture.
 If you want smaller sizes, you can use the parameters in the table below.
 For example:
 https://image.tmdb.org/t/p/w780/bOGkgRGdhrBYJSLpXaxhXVstddV.jpg
 https://image.tmdb.org/t/p/w300/bOGkgRGdhrBYJSLpXaxhXVstddV.jpg
 or with a poster
 https://image.tmdb.org/t/p/w92/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/w154/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/w185/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/w342/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/w500/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/w780/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 https://image.tmdb.org/t/p/original/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg
 
 ## Add Supported Image Sizes
 Min Res      Max Res
 poster   = Poster ............  500 x 750   2000 x 3000
 backdrop = Fanart ............ 1280 x 720   3840 x 2160
 still    = TV Show Episode ... 1280 x 720   3840 x 2160
 profile  = Actors Actresses ..  300 x 450   2000 x 3000
 logo     = TMDb Logo
 
 ## API Supported Image Sizes
 
 |  poster  | backdrop |  still   | profile  |   logo   |
 | :------: | :------: | :------: | :------: | :------: |
 | -------- | -------- | -------- |    w45   |    w45   |
 |    w92   | -------- |    w92   | -------- |    w92   |
 |   w154   | -------- | -------- | -------- |   w154   |
 |   w185   | -------- |   w185   |   w185   |   w185   |
 | -------- |   w300   |   w300   | -------- |   w300   |
 |   w342   | -------- | -------- | -------- | -------- |
 |   w500   | -------- | -------- | -------- |   w500   |
 | -------- | -------- | -------- |   h632   | -------- |
 |   w780   |   w780   | -------- | -------- | -------- |
 | -------- |  w1280   | -------- | -------- | -------- |
 | original | original | original | original | original |
 
 Original Size is the size of the uploaded image.
 It can be between Minimum Resolution and Maximum Resolution.
 */
