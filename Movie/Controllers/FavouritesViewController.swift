import UIKit

class FavouritesViewController:UIViewController{
    @IBOutlet weak var FavouritesTableView: UITableView!
    var movies:[ApiMovie] = []
    @Injected(\.storage) private var storage: MovieStorage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movies = storage.load()
        for mov in self.movies{
            let loadImage = MovieDetail(movie: mov)
            loadImage.load(string: "https://image.tmdb.org/t/p/original\(mov.poster_path ?? "")")
            loadImage.loadDetails()
            Movies.imageArray.Images[mov.title] = loadImage
        }
        self.FavouritesTableView.dataSource = self
        self.FavouritesTableView.delegate = self
        self.registerTableViewCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.movies = storage.load()
        FavouritesTableView.reloadData()
    }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
       return movies.count
   }
   
   func tableView(_ tableView: UITableView,
                  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
           cell.movie = movies[indexPath.row]
           cell.title.text = cell.movie?.title
           cell.genre.text = cell.movie?.getGenres()
           cell.year.text = cell.movie?.release_date
           cell.duration.text = String(Movies.imageArray.Images[movies[indexPath.row].title]?.runtime ?? 0) + " minutes"
           cell.poster.image = Movies.imageArray.Images[movies[indexPath.row].title]?.posterImage
           if  storage.exist(record: cell.movie!){
               cell.movie?.isFavorite = true
               cell.favorite.setImage(UIImage(systemName: "star.fill")!, for: .normal)
           }
           else{
               cell.movie?.isFavorite = false
               cell.favorite.setImage(UIImage(systemName: "star")!, for: .normal)
           }
           cell.onStarDeselected = {
               self.movies = self.storage.load()
               tableView.reloadData()
           }
           cell.posterSelected = {
               print("poster pressed")
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
               vc?.movie = cell.movie
               self.present(vc!, animated: true)
           }
           return cell
       }
       
       return UITableViewCell()
   }
   
   private func registerTableViewCells() {
       let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                 bundle: nil)
       self.FavouritesTableView.register(textFieldCell,
                               forCellReuseIdentifier: "CustomTableViewCell")
   }
}
