//
//  testcollect.swift
//  TheMovieDB
//
//  Created by jianli on 4/9/22.
//
import UIKit
class testViewController: UIViewController {
    let colors:[UIColor] = [.blue, .green, .gray, .red, .cyan]
    var arrayImages = [Data]()
    lazy var collectTV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame:.zero,collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .lightGray
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        //downloadImage()
    }
    func setupUI(){
        view.addSubview(collectTV)
        let safeArea = view.safeAreaLayoutGuide
        collectTV.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectTV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectTV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        collectTV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true


    }
    func downloadImage(){
        let size = UIScreen.main.bounds
        let urlStr = "https://picsum.photos/\(Int(size.width))/\(Int(size.height))"
        guard let url = URL(string:urlStr) else {return}
        let dg = DispatchGroup()
        for _ in 0..<10{
            dg.enter()
            URLSession.shared.dataTask(with: url){[weak self] data,res,e in
                if let data = data{
                    print("load",url)
                    self?.arrayImages.append(data)
                }
                dg.leave()
            }.resume()
            
        }
        dg.notify(queue: .main){
            self.collectTV.reloadData()
        }
    }
}

extension testViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
        //return arrayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectTV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        //cell.backgroundView = UIImageView(image:UIImage(data:self.arrayImages[indexPath.row]))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

