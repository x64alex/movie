//
//  SearchCollectionViewController.swift
//  Movie
//
//  Created by Yopeso on 01.08.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UICollectionViewController {

    var dataSource: DataSource!
    var searchedMovies:[Movie] = Movie.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        //let c = closure()
        
    }
}
let compositionalLayoutSearchView: UICollectionViewCompositionalLayout = {
    let fraction: CGFloat = 1.6 / 3.0
    
    // Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(0.7))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    section.orthogonalScrollingBehavior = .continuous

    return UICollectionViewCompositionalLayout(section: section)
}()
