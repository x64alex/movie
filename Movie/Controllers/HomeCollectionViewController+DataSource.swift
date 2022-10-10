import UIKit

extension HomeCollectionViewController{
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        if popularMovies.contains(id: id)
        {
            let reminder = moviePopular(for: id)
            var backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
            backgroundConfiguration.image = reminder.posterImage
            backgroundConfiguration.cornerRadius = 15
            cell.backgroundConfiguration = backgroundConfiguration
        }
        else if upcomingMovies.contains(id: id)
        {
            let reminder = movieUpcoming(for: id)
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.image = reminder.posterImage
            backgroundConfiguration.cornerRadius = 15
            cell.backgroundConfiguration = backgroundConfiguration
        }
        else if topRatedMovies.contains(id: id){
            let reminder = movieTop(for: id)
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.image = reminder.posterImage
            backgroundConfiguration.cornerRadius = 15
            cell.backgroundConfiguration = backgroundConfiguration
        }

    }
    func updateSnapshot() {
        
        var snapshot = Snapshot()
        snapshot.appendSections([0,1,2])
        snapshot.appendItems(popularMovies.map { $0.id },toSection: 0)
        snapshot.appendItems(upcomingMovies.map { $0.id },toSection: 1)
        snapshot.appendItems(topRatedMovies.map { $0.id },toSection: 2)
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
    
    func moviePopular(for id: Movie.ID) -> Movie {
        let index = popularMovies.indexOfMovie(with: id)
        return popularMovies[index]
    }
    func movieUpcoming(for id: Movie.ID) -> Movie {
        let index = upcomingMovies.indexOfMovie(with: id)
        return upcomingMovies[index]
    }
    func movieTop(for id: Movie.ID) -> Movie {
        let index = topRatedMovies.indexOfMovie(with: id)
        return topRatedMovies[index]
    }
    func updatePopoluar(_ movie: Movie, with id: Movie.ID) {
        let index = popularMovies.indexOfMovie(with: id)
        popularMovies[index] = movie
    }
}
