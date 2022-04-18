//
//  Repository.swift
//  TheMovieDB
//
//  Created by jianli on 4/6/22.
//

import Foundation
import Combine
import CoreData

class Repository{

    
    lazy var context = MovieCoreData.context
    private var page = 1
    private let networkManager:NetworkManager
    private var subscribers = Set<AnyCancellable>()
    
    
    init(_ networkManager:NetworkManager){
        self.networkManager = networkManager
    }
//
//    func getMovieData(user:String)->[MovieModel]{
//        // TODO:
//        // (1) download movie page 1 , save to database, (1.1) download poster Image save to database
//        // (2) download movie details, (2.1) download poster Image save to databas
//        // (3) publish a update signal, viewmodel get it and will update array
//        
//       return []
//    }
    
    //MARK: PRIVATE FUNTIONS
    func getMovieData(page:Int,_ completionHandler: @escaping (Result<[MovieModel], NetworkError>)->Void){
        networkManager.getModel(PageModel.self, url:  NetworkURL.movieURL("\(page)"))
            .sink{_ in} receiveValue:{ data in
                let movieData = data.results
                completionHandler(.success(movieData))
            }.store(in: &subscribers)
    }
    func getMovieDetailsData(_ id:Int,_ completionHandler: @escaping (MovieDetailModel)->Void){
        networkManager.getModel(MovieDetailModel.self, url: NetworkURL.detailURL("\(id)"), completionHandle: completionHandler)
    }
    func getPosterData(from url:NetworkURL, _ completionHandler: @escaping (Result<Data,NetworkError>)->Void){
        networkManager.getPosterImage(url: url){ data in
            if let data = data{
                completionHandler(.success(data))
            }else{
                completionHandler(.failure(NetworkError.badURL))
            }
        }
    }
    //  MARK: - about database
    func saveMovieData(user:String?,movieData:[MovieModel]){
        if let user = user{
            var favorIds:[Int] = movieData.filter{$0.favor ?? false}.map{$0.id}
            guard let fetchDesc = NSEntityDescription.entity(forEntityName: "EntityFavor", in: context) else{return}
            let fetchRequest = EntityFavor.fetchRequest()
            do{
                fetchRequest.predicate = NSPredicate(format:"user=%@",user)
                let fetchResult = try context.fetch(fetchRequest)
                for result in fetchResult{
                    let rid = Int(result.id)
                    if favorIds.contains(rid){
                        
                    }else{
                        // delete user-id key
//                        var newFavor = EntityFavor(entity: fetchDesc, insertInto: context)
//                        newFavor.setValue(Int64(rid),forKey: "id")
//                        newFavor.setValue(user,forKey: "user")
                       context.delete(result)
                    }
                    if let index = favorIds.firstIndex(of: rid){
                        favorIds.remove(at: index)
                    }
                }
                // rest id need to add
                if favorIds.count != 0{
                    // save id
                    for rid in favorIds{
                        let newFavor = EntityFavor(entity: fetchDesc, insertInto: context)
                        newFavor.setValue(Int64(rid),forKey: "id")
                        newFavor.setValue(user,forKey: "user")
                        }
                }
                try context.save()
            }catch (let error){
                print(error.localizedDescription)
            }
        }
    }
    func updateMovieData(user:String?,movieData:inout [MovieModel]){
        // (1.1) save to database
        if let user = user{
            //guard let fetchDesc = NSEntityDescription.entity(forEntityName: "EntityFavor", in: context) else{return}
            let fetchRequest = EntityFavor.fetchRequest()
            do{
                for (pos,oneMovie) in movieData.enumerated(){
                    fetchRequest.predicate = NSPredicate(format:"user=%@ && id=%d",user,oneMovie.id)
                    let fetchResult = try context.fetch(fetchRequest)
                    if fetchResult.count == 0{
                        
                    }else{
                        movieData[pos].favor = true
                    }
                }
                try context.save()
            }catch (let error){
                print(error.localizedDescription)
            }
        }
    }
    
    func removeAllData() {
        let request:NSFetchRequest = EntityFavor.fetchRequest()
        do{
            let posts = try context.fetch(request)
            for post in posts{
                context.delete(post)
            }
            try context.save()
        }catch(let error){
            print(error.localizedDescription)
        }
    }
}
