//
//  CustomCollectionViewCell.swift
//  Books
//
//  Created by Eduardo Antonio Pérez Muñoz on 5/16/18.
//  Copyright © 2018 com.test.books. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var anImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        anImage.image = nil
    }
    
    func setup(using book: Book){
        
        titleLabel.text = book.title
        authorLabel.text = book.authorString
        
        if let stringUrl = book.thumbnailURL,
            let url = URL(string: stringUrl) {
            anImage.kf.setImage(with: url)
        }
    }
}
