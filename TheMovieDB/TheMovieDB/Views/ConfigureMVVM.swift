//
//  ConfigureMVVM.swift
//  TheMovieDB
//
//  Created by jianli on 4/6/22.
//

import UIKit

class ConfigureMVVM{
    static func configure(_ mainViewController:MainViewController){
        let networkManager = NetworkManager()
        let repository = Repository(networkManager)
        
        let viewModel = MovieViewModel(repository: repository)
        mainViewController.viewModel = viewModel
        let mainTableView = MainTableView(controller:mainViewController)
        //mainTableView.viewModel = viewModel
        // viewModel must defined firste, because mainTableView wilk use it 
        mainViewController.tableView = mainTableView
        
    }
}


