//
//  DetailsViewController.swift
//  TheMovieDB
//
//  Created by jianli on 4/8/22.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController{
    static let identiferCell = "CollectionCell"
    private var detailViewModel:DetailViewModel
    var parentView:MainTableView?
    //var data:MovieModel
    var row:Int?
    
    let colors:[UIColor] = [.blue, .green, .gray, .red, .cyan]
    var arrayImages = [Data]()

    
    var posterImageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.backgroundColor = .blue
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let companyTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Production companies"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let detailsLabel:UILabel = {
        let label = UILabel()
        label.text = "overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 10
        //label.lineBreakMode = .byCharWrapping//UILineBreakModeWordWrap
        return label
    }()
    
    lazy var collection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screensize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width:screensize.width/2, height:screensize.height/4)
        //layout.minimumLineSpacing = 0
        //layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DetailsViewController.identiferCell)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        return collection
    }()
    
    init(_ data:MovieModel,repository:Repository){
        
        self.detailViewModel = DetailViewModel(movieData:data,repository: repository)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        if let navigation = self.navigationController{
            navigation.isNavigationBarHidden = false
            navigation.navigationBar.topItem?.title = detailViewModel.movieData.title
            //navigation.navigationItem.hidesBackButton = true
            navigation.navigationBar.topItem?.backButtonTitle = "Movies"
            let switcher = UISwitch()
            switcher.addTarget(self, action: #selector(switchFavor(sender:)), for: .valueChanged)
            switcher.isOn = self.detailViewModel.movieData.favor ?? false
            let switcherBarItem = UIBarButtonItem(customView: switcher)
            navigation.navigationBar.topItem?.rightBarButtonItem = switcherBarItem
        }
    }
    override func viewWillAppear(_ animated: Bool) {

        
    }
    
    private func configure(){
        //self.detailViewModel.loadData(detailVC:self)
        // check is in the core data
        //detailViewModel.configureData{}
        let data = detailViewModel.movieData
        let context = parentView?.viewModel.repository.context;
        let fetchRequest = EntityMovieDetails.fetchRequest()
        do{
            fetchRequest.predicate = NSPredicate(format:"id=%d",data.id)
            let fetchResult = try context!.fetch(fetchRequest)
            if fetchResult.count != 0{
                
            }else{
                downloadData(id: data.id)
//                let desc = NSEntityDescription.entity(forEntityName: "EntityMovieDetails", in: context!)
//                let entity = EntityMovieDetails(entity: desc!, insertInto: context)
//                entity.setValue(data.id, forKey: "id")
//                entity.setValue(data.title, forKey: "title")
//                entity.setValue(data.overview, forKey: "overView")
                //try context?.save()
            }
        }catch(let e){
            print(e.localizedDescription)
        }
    }
    private func downloadData(id:Int){
        let semaphore = DispatchSemaphore(value: 0)
        
        parentView?.viewModel.repository.getMovieDetailsData(id){ [weak self] data in
            if let self = self{
                DispatchQueue.main.async {
                    self.titleLabel.text = data.title
                    self.detailsLabel.text = data.overview
                    if let path = data.posterPath{
                        //self.configurePoster()
                        self.parentView?.viewModel.repository.getPosterData(from:NetworkURL.imageURL(ImageSize.w342,path)){[weak self] result in
                            switch result{
                            case .failure(let e):
                                print(e.localizedDescription)
                            case .success(let image):
                                let image =  UIImage(data:image)
                                DispatchQueue.main.async {
                                    self?.posterImageView.image = image
                                }
                            }
                        }
                    }
                    // update companies
                    self.detailViewModel.updateCompanyData(detailData: data,self)
                    self.collection.reloadData()
                    // semaphore
                    
                    
                }
                semaphore.signal()
            }}
        _ = semaphore.wait(timeout:.distantFuture)
        // save data
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(detailsLabel)
        view.addSubview(collection)
        view.addSubview(companyTitleLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            posterImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor,constant:10),
            detailsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),

            companyTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor,constant: 10),
            companyTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant:10),

            collection.topAnchor.constraint(equalTo: companyTitleLabel.bottomAnchor),
            collection.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3),
            collection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant:10),
            collection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            //collection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            
        ])
    }

    @objc func switchFavor(sender:UISwitch){
        parentView?.setFavor(sender.isOn, self.detailViewModel.movieData.id)
    }
}

extension DetailsViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailViewModel.companies?.count ?? 0
        //return colors.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collection.dequeueReusableCell(withReuseIdentifier: DetailsViewController.identiferCell, for: indexPath)
        let company = detailViewModel.companies![row]
        let imageView = UIImageView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width/2,height:UIScreen.main.bounds.height/4))
        imageView.contentMode = .scaleAspectFit
        if let data = company.logoData{
            imageView.image = UIImage(data:data)
        }
        let nameLabel = UILabel.init(frame: CGRect(x:0,y:150,width:200,height:20))
        nameLabel.text = company.name
        nameLabel.textAlignment = .center
        cell.addSubview(imageView)
        cell.addSubview(nameLabel)
//        let cell = collection.dequeueReusableCell(withReuseIdentifier: DetailsViewController.identiferCell, for: indexPath)
//        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    
    
}
