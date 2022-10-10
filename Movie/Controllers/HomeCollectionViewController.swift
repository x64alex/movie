import UIKit

class HomeCollectionViewController: UICollectionViewController {
    var dataSource: DataSource!
    var popularMovies:[Movie] = []
    var upcomingMovies:[Movie] = []
    var topRatedMovies:[Movie] = []
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = compositionalLayout
        configureDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let c = closure()
        
        let popularMovie = { (movies: [ApiMovie]) in
          for mov in movies {
              let newMovie = Movie(title: mov.title,poster: mov.poster_path ?? "")
              newMovie.load(string: "https://image.tmdb.org/t/p/original\(mov.poster_path!)")
              self.popularMovies.append(newMovie)
          }
            DispatchQueue.global().async {
              self.updateSnapshot()
          }
        }
        
        c.fetchPopularMovies(completion: popularMovie)
        
        let upcomingMovie = { (movies: [ApiMovie]) in
          for mov in movies {
              let newMovie = Movie(title: mov.title, poster: mov.poster_path ?? "")
              newMovie.load(string: "https://image.tmdb.org/t/p/original\(mov.poster_path!)")
              //print(newMovie.poster)
              self.upcomingMovies.append(newMovie)
          }
            DispatchQueue.global().async {
                print("Movies",self.upcomingMovies.count)
              self.updateSnapshot()
          }
        }
        
        c.fetchUpcomigMovies(completion: upcomingMovie)
        
        let topMovie = { (movies: [ApiMovie]) in
          for mov in movies {
              let newMovie = Movie(title: mov.title, poster: mov.poster_path ?? "")
              newMovie.load(string: "https://image.tmdb.org/t/p/original\(mov.poster_path!)")
              self.topRatedMovies.append(newMovie)
          }
            DispatchQueue.global().async {
              self.updateSnapshot()
          }
        }
        
        c.fetchTopRatedMovies(completion: topMovie)
    }
    
    
}
let compositionalLayout: UICollectionViewCompositionalLayout = {
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
    

    //Header
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

    // this activates the "sticky" behavior
    headerElement.pinToVisibleBounds = true
    //section.boundarySupplementaryItems = [headerElement]

    var  layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}()
