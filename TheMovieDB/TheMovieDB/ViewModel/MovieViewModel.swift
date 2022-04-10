//
//  MovieViewModel.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import Foundation

class MovieViewModel{
    @Published var movieData:[MovieModel] = [MovieModel]()
    @Published var posterData = [Int:Data]()
    var user:String?
    
    var moviePublisher:Published<[MovieModel]>.Publisher{$movieData}
    var posterPublisher:Published<[Int:Data]>.Publisher{$posterData}
    
    let repository:Repository
    private var isLoading = false
    
    private var page = 1
   
    init(repository:Repository){
        self.repository = repository
    }
    
    func loadMoreData(){
        page += 1
        loadData(isAppend: true)
    }
    func loadData(isAppend:Bool=false){
        guard !isLoading else{return}
        isLoading = true
        repository.getMovieData(page:page){ [weak self] result in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                if let self = self{
                    if isAppend{
                        self.movieData.append(contentsOf:data)
                    }else{
                        self.movieData = data
                    }
                    self.repository.updateMovieData(user:self.user,movieData:&self.movieData)
//                    let favors = self.repository.updateMovieData(self.movieData)
//                    if favors.count == self.movieData.count{
//                        _ = favors.enumerated().map{self.movieData[$0.0].favor = $0.1}
//                    }
                    self.updateImageData()
                    self.isLoading = false
                }
            }
        }
    }
    private func updateImageData(){
        var tempImageData = [Int:Data]()
        let group = DispatchGroup()
        for movie in movieData{
            if posterData[movie.id] == nil,let posterPath = movie.posterPath{
                group.enter()
                repository.getPosterData(from:NetworkURL.imageURL(ImageSize.w92,posterPath)){ result in
                    switch result{
                    case .success(let data):
                        tempImageData[movie.id] = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main){[weak self] in
            self?.posterData = tempImageData
        }
    }
    func forceUpdate(){
        movieData = []
        posterData = [:]
        repository.removeAllData()
        page = 1
        loadData()
    }
    func deleteData(row:Int){
        movieData.remove(at:row)
        if posterData[row] != nil{
            posterData.removeValue(forKey: row)
        }
    }
    func getMovieData(by row:Int) -> MovieModel?{
        guard row < movieData.count else {return nil}
        return movieData[row]
    }
    func saveMovieData(){
        self.repository.saveMovieData(user:user,movieData:movieData)
    }
    func updateFavor(_ isOn:Bool, _ id:Int){
        var index = self.movieData.firstIndex(where: {
            $0.id == id
        })
        self.movieData[index!].favor = isOn
        self.saveMovieData()
    }
}
