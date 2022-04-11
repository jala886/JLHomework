//
//  ViewController.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import UIKit

class MainViewController: UIViewController{
    // MARK: DEFINED interfaces
    var viewModel:MovieViewModel?
    var tableView:MainTableView?
    
    
    private lazy var refreshAction:UIAction = UIAction{[weak self] _ in
        self?.viewModel?.forceUpdate()
        self?.refreshControl.endRefreshing()
        self?.tableView?.reloadData()
    }
    private lazy var refreshControl:UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero, primaryAction: refreshAction)
        return refresh
    }()
    
//    init(viewModel:MovieViewModel){
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = greetPrefix
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var editIconVC:UIImageView = {
        let editIcon = UIImageView(image: UIImage(systemName:"square.and.pencil"))
        editIcon.translatesAutoresizingMaskIntoConstraints = false
        return editIcon
    }()
    var editIconButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName:"square.and.pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(callLoginVC), for: .touchUpInside)
        return button
    }()
    
    lazy var segments:UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints=false
        for item in SegmentType.allCases{
            segment.insertSegment(withTitle: item.name, at: item.position, animated: true)
            //print(item)
        }
//        segment.insertSegment(withTitle: "Movies list", at: 0, animated: true)
//        segment.insertSegment(withTitle: "Favorites", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(setSegmentType), for: .valueChanged)
        return segment
    }()
    // MARK: segmentAction
//    lazy var segmentAction:UIAction = UIAction { action in
//        let segment = action.sender as? UISegmentedControl
//        let segmentType = SegmentType(rawValue:segment?.selectedSegmentIndex ?? 0)
//        self.setSegmentType(segmentType ?? SegmentType.MovieList)
//    }

    // MARK: - DEFINED FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        // Do any additional setup after loading the view.
        try! configure()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.topItem?.title = "Movies"
        self.navigationController?.isNavigationBarHidden = true
        tableView?.searcher.searchBar.isHidden = false
        let name = UserDefaults.standard.string(forKey: userNameSaveKey)
        if let name = name{
            nameLabel.text = greetPrefix + name
            self.viewModel?.user = name
            self.tableView?.viewModel.loadData()
            self.tableView?.updateMovieData()
        }else{
            print(NormError.userNameError("user not save in UserDefaults"))
        }
    }
    private func configure() throws{
        ConfigureMVVM.configure(self)
       
        
    }
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(editIconButton)
        view.addSubview(segments)
        self.tableView?.addSubview(refreshControl)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20),
            //editIconButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            editIconButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -20),
            editIconButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            editIconButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            segments.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segments.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            segments.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
        ])
        if let tableView = self.tableView {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: segments.bottomAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        }
    }

    @objc private func callLoginVC(){
        //print(self.navigationController?.viewControllers)
        //print("call login view Controller")
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true)
        //present(loginVC,animated: true)
        
    }
    
    var segmentType = SegmentType.MovieList
    
    @objc private func setSegmentType(){
        let segmentType = SegmentType(rawValue:segments.selectedSegmentIndex ?? 0)
        self.segmentType = segmentType!
        if let view = self.tableView as? MainTableView{
            view.updateMovieData()
        }
    }
}

