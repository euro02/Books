//
//  Network.swift
//  Books
//
//  Created by Eduardo Antonio Pérez Muñoz on 5/16/18.
//  Copyright © 2018 com.test.books. All rights reserved.
//

import UIKit

class Network {
    
    static var googleAPIBooks : String = "https://www.googleapis.com/books/v1/volumes?q="
    static var noThumbnail : String = "http://webmaster.ypsa.org/wp-content/uploads/2012/08/no_thumb.jpg"
    
    class func makeRequestWithQuery(query:String, completion: @escaping ([Book]) -> Void) {
        let finalURL = googleAPIBooks + query
        guard let url = URL(string: finalURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                completion([])
            }
            guard let data = data else {
                completion([])
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                return
            }
            
            guard let items = json?.object(forKey: "items") as? NSArray else {
                completion([])
                return
            }

            var results: [Book] = []
            for element in items {
                
                guard let volumeInfo = (element as? NSDictionary)?.object(forKey: "volumeInfo") as? NSDictionary else {
                    continue
                }
                
                let title = volumeInfo.object(forKey: "title") as? String ?? "No title available"
                let author = (volumeInfo.object(forKey: "authors") as? [String]) ?? ["No author avaialble"]
                let imageURL = (volumeInfo.object(forKey: "imageLinks") as? NSDictionary)?.object(forKey: "smallThumbnail") as? String ?? noThumbnail
                
                let book = Book(title: title, authors: author, thumbnailURL: imageURL)
                results.append(book)

            }
            completion(results)
        }.resume()
    }
}

extension UIViewController {
    
    func displayAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
