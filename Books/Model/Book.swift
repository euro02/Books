//
//  Book.swift
//  Books
//
//  Created by Eduardo Antonio Pérez Muñoz on 5/16/18.
//  Copyright © 2018 com.test.books. All rights reserved.
//

import UIKit

struct Book {
    var title: String
    var thumbnailURL: String?
    var authors: [String]
    
    var authorString: String {
        return authors.joined(separator: ", ")
    }

    init(title:String, authors: [String], thumbnailURL:String) {
        self.title = title
        self.authors = authors
        self.thumbnailURL = thumbnailURL
    }
}
