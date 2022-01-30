//
//  ArticleCollectionViewCell.swift
//  Report.
//
//  Created by Amogh Kalyan on 11/28/21.
//  Setup for the collection view to display articles properly

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    func view_setup(with temp: Article) {
        titleLabel.text = temp.title
        
        //converting String URL to UIImage
        let urlString = temp.image
        
        let url = URL(string: urlString)!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
        
        descriptionLabel.text = temp.description
    }
}
