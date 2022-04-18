//
//  MainVCTableVC.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import UIKit
import Combine

class MainTableView:UITableView{
    private let controller:MainViewController
    let viewModel:MovieViewModel
    private var subscribers = Set<AnyCancellable>()
    private var tmpMovieData = [MovieModel]()
    //MARK: - FOR TEST
    let testData = ["hello","world","I","like","it","hope","tohp"]
    lazy var dynamicData:[String] = testData
    var segmentType:SegmentType = SegmentType.MovieList
    
    //MARK: -
    func setSegmentType(_ segmentType:SegmentType){
        self.segmentType = segmentType
        self.updateMovieData()
        // TODO: reloadData()
        //self.reloadData()
    }
    
    var searcher = UISearchController(searchResultsController: nil)
    //MARK: private define
    init(controller:MainViewController){
        self.controller = controller
        self.viewModel = controller.viewModel!
        super.init(frame: .zero, style: .plain)
        setupUI()
        self.dataSource = self
        self.prefetchDataSource = self
        self.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        self.rowHeight = UITableView.automaticDimension
        addBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var textField:UITextField = {
        let textField = UITextField()
        textField.leftView = UIImageView(image:UIImage(systemName:"magnifyingglass"))
        return textField
    }()
    
    private func setupUI(){
        self.accessibilityActivate()
        self.accessibilityIdentifier = "Main.Table.View"
        //backgroundColor = .blue
        //let searcher = UISearchController(searchResultsController: nil)
        //searcher.searchResultsUpdater = self
        searcher.hidesNavigationBarDuringPresentation = false
        searcher.searchBar.delegate = self
        searcher.dimsBackgroundDuringPresentation = false
        searcher.searchBar.sizeToFit()
        tableHeaderView = searcher.searchBar
        
    }
    private func addBindings(){
        viewModel.moviePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink{[weak self] (res:Any) in
                self?.reloadData()
            }.store(in: &subscribers)
        viewModel.posterPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink{[weak self] (res:Any) in
                self?.updateMovieData()
                //self?.reloadData()
            }.store(in: &subscribers)
    }
    // MARK: KEY UPDATE FUNCTION
    func updateMovieData(filerText:String?=nil){
        self.tmpMovieData = controller.segmentType == SegmentType.Favorites ? viewModel.movieData.filter{$0.favor ?? false} : viewModel.movieData
        if let filerText = filerText {
            self.tmpMovieData = tmpMovieData .filter{$0.title.lowercased().contains(filerText.lowercased()) || ($0.overview.lowercased().contains(filerText.lowercased()))
            }
        }else{
        }
        self.reloadData()
        
    }
}

extension MainTableView:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            //dynamicData = testData.filter{$0.starts(with: searchText.lowercased())}
            //dynamicData = testData.filter{$0.contains(searchText.lowercased())}
            updateMovieData(filerText: searchText)
        }else{
            updateMovieData()
        }
    }
}
//extension MainTableView:UISearchResultsUpdating{
//
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, searchText != ""{
//            dynamicData = testData.filter{$0.contains(searchText.lowercased())}
//            reloadData()
//        }
//    }
//}
extension MainTableView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dynamicData.count
        //viewModel.movieData.count
        tmpMovieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: MainTableViewCell.identifier)
        //cell.textLabel?.text = dynamicData[row]
        if let cell = cell as? MainTableViewCell{
            //let data = viewModel.movieData[row]
            let data = tmpMovieData[row]
            cell.configure(in:data)
            if let imageData = viewModel.posterData[data.id]{
                cell.setPosterView(in: imageData)
            }
            //cell.detailButton.sendAction(callDetails(row))
            //cell.detailButton.addTarget(self, action: #selector(callDetails(row:row)), for: .touchUpInside)
            cell.detailButton.tag = row
            cell.detailButton.addTarget(self, action: #selector(callDetail(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc private func callDetail(sender:UIButton){
        //print("call Detail",sender.tag)
        let detailsVC = DetailsViewController(tmpMovieData[sender.tag],repository: viewModel.repository)
        detailsVC.parentView = self
        //detailsVC.data =
        detailsVC.row = sender.tag
        searcher.searchBar.isHidden = true
        if let navigation = controller.navigationController{
            //navigation.title = "Movies"
            //navigation.navigationBar.topItem?.title = "Movies"
            //navigation.navigationItem.backBarButtonItem?.title = "Movies"
            //navigation.navigationItem.backButtonTitle = "Movies"
            navigation.pushViewController(detailsVC, animated: true)
        }
    }
    func setFavor(_ isOn:Bool, _ id:Int){
        self.viewModel.updateFavor(isOn,id)
        updateMovieData()
        //self.viewModel.saveMovieData()
    }
    
}

extension MainTableView:UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{$0.row}
        if rows.contains(viewModel.movieData.count-1){
            viewModel.loadMoreData()
        }
    }
    
    
}
