//
//  MainTableViewCell.swift
//  TheMovieDB
//
//  Created by jianli on 4/7/22.
//

import UIKit
import Combine

class MainTableViewCell:UITableViewCell{
    static let identifier = "MainTableViewCell"
    
    let posterImageView:UIImageView = {
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let overviewLabel:UILabel = {
        let label = UILabel()
        label.text = "overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        //label.lineBreakMode = .byCharWrapping//UILineBreakModeWordWrap
        return label
    }()
    
    let favorLabel:UILabel = {
        let label = UILabel()
        label.text = "✅"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.configuration = UIButton.Configuration.filled()
        button.backgroundColor = .blue
        button.setTitle("Show Details", for: .normal)
        //button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        button.titleLabel?.font = UIFont.systemFont(ofSize:10)
        button.sizeToFit()
        //button.addTarget(self, action: #selector(callDetail(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    private func setupUI(){
        //self.contentView.backgroundColor = .blue
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(overviewLabel)
        self.contentView.addSubview(favorLabel)
        self.contentView.addSubview(detailButton)
        
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -5),
            detailButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant:-10),
            detailButton.leadingAnchor.constraint(equalTo: favorLabel.leadingAnchor,constant:-40),
            
            posterImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: 5),
            posterImageView.heightAnchor.constraint(equalToConstant: 230),
            posterImageView.widthAnchor.constraint(equalToConstant: 140),
            
            favorLabel.bottomAnchor.constraint(equalTo: detailButton.topAnchor,constant:-10),
            favorLabel.trailingAnchor.constraint(equalTo: detailButton.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            //titleLabel.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor,constant:10),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 5),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor),
            //overviewLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
        ])
    }
    
    func configure(in movie:MovieModel){
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        favorLabel.isHidden = !(movie.favor ?? false)
        //favorLabel.isEnabled = !favorLabel.isEnabled
        
    }
    func setPosterView(in data:Data){
        posterImageView.image = UIImage(data: data)
    }
//    
//    @objc private func callDetail(sender:UIButton){
// 
//        //print("call Detail",sender.tag)
//    }
}
