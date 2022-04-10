//
//  MovieViewModel.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import Foundation
import UIKit

class DetailViewModel{
    @Published var detailData:MovieDetailModel?
    //var publisher : Published<Any>.Publisher{$detailData}
    var posterData:Data?
    var companies:[ProductionCompany]?
    var movieData:MovieModel
    
    private let repository:Repository
    
    init(movieData:MovieModel,repository:Repository){
        self.repository = repository
        self.movieData = movieData
        //self.loadData()
    }
    
    func loadData(detailVC:DetailsViewController){
        repository.getMovieDetailsData(movieData.id){ [weak self] data in
            if let self = self{
                //self.detailData = data
                DispatchQueue.main.async {
                    detailVC.titleLabel.text = data.title
                    detailVC.detailsLabel.text = data.overview
                }
                if let path = data.posterPath{
                    self.repository.getPosterData(from:NetworkURL.imageURL(ImageSize.w342,path)){[weak self] result in
                        switch result{
                        case .failure(let e):
                            print(e.localizedDescription)
                        case .success(let image):
                            let imagview = UIImageView(image: UIImage(data:image))
                            DispatchQueue.main.async {
                                detailVC.posterImageView = imagview
                            }
                        }
                    }
                }
                //self.updateCompanyData(detailData:data)
            }
        }

        
    }

    func updateCompanyData(detailData:MovieDetailModel,_ detailVC:DetailsViewController){
        self.companies = detailData.productionCompanies
        let group = DispatchGroup()
        for (pos,company) in companies!.enumerated(){
            if let logoPath = company.logoPath{
                group.enter()
            repository.getPosterData(from:NetworkURL.imageURL(ImageSize.w92,logoPath)){ [weak self] result in
                    switch result{
                    case .success(let data):
                        self?.companies?[pos].logoData = data
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
        }
        //group.wait()
        group.notify(queue: .main){
                print("downloaded logo image")
            DispatchQueue.main.async {
                detailVC.collection.reloadData()
            }
        }
    }
}
