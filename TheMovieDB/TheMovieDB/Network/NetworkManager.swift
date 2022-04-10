//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by jianli on 4/7/22.
//

import Foundation
import Combine


class NetworkManager{
    func getModel<T:Decodable>(_ model:T.Type,url:NetworkURL)->AnyPublisher<T,NetworkError>{
        guard let url = URL(string:url.url)
        else{return Fail(error:.badURL).eraseToAnyPublisher()}
        return  URLSession.shared.dataTaskPublisher(for: url)
            .mapError{
                return NetworkError.netError($0)
            }
            .map{$0.data}
            .decode(type:T.self, decoder: JSONDecoder())
            .mapError{
                return .decodeError($0)
            }.eraseToAnyPublisher()
        
    }
    func getModel<T:Decodable>(_ model:T.Type,url:NetworkURL,completionHandle:@escaping (T)->Void){
        guard let url = URL(string:url.url)
        else{return}
        URLSession.shared.dataTask(with: url){ data, res, error in
            if let data = data{
                do{
                let res = try JSONDecoder().decode(T.self, from: data)
                completionHandle(res)
                }catch(let e){
                    print(e.localizedDescription)
                }
            }
        }.resume()
    }
    func getPosterImage(url:NetworkURL, completionHandle: @escaping (Data?)->Void){
        guard let url = URL(string:url.url)
        else{return}
        URLSession.shared.dataTask(with: url){ data, res, error in
            completionHandle(data)
        }.resume()
        
    }
}
