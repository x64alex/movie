//
//  SearchCollectionViewController+DataSource.swift
//  Movie
//
//  Created by Yopeso on 05.08.2022.
//

import UIKit

extension SearchCollectionViewController{
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
            let movie = movieSearched(for: id)
            var backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
            backgroundConfiguration.image = movie.posterImage
            backgroundConfiguration.cornerRadius = 15
            cell.backgroundConfiguration = backgroundConfiguration

    }
    func updateSnapshot() {
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(searchedMovies.map { $0.id },toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func configureDataSource()
    {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        updateSnapshot()
        collectionView.dataSource = dataSource

    }
    
    func movieSearched(for id: Movie.ID) -> Movie {
        let index = searchedMovies.indexOfMovie(with: id)
        return searchedMovies[index]
}
}
