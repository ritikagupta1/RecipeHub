//
//  RecipeImageView.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 26/10/21.
//

import UIKit
import Kingfisher

class RecipeImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "placeholder")
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 20
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let placeholderImage = UIImage(named: "placeholder")
        let resource = ImageResource(downloadURL: url)
        kf.setImage(with: resource, placeholder: placeholderImage)
    }
}
