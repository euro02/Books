//
//  ViewController.swift
//  Books
//
//  Created by Eduardo Antonio Pérez Muñoz on 5/16/18.
//  Copyright © 2018 com.test.books. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "cell"

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var arrayOfElements: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UICollectionViewDelegate { }

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var screenAdjustableWidht : CGFloat
        screenAdjustableWidht = screenWidth/2 - 10
        return CGSize(width: screenAdjustableWidht, height: screenAdjustableWidht*16/9);
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        let element = self.arrayOfElements[indexPath.row]
        cell.setup(using: element)
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        guard let escapedString = query.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        self.activityIndicator.startAnimating()
        Network.makeRequestWithQuery(query: escapedString) { [unowned self] array in
            self.arrayOfElements = array
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            if array.isEmpty {
                self.displayAlert(title: "Error", message: "No results available")
            }
        }
    }
}
