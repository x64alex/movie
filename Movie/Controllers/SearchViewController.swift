import UIKit

class SearchViewController: UIViewController{
    let c = closure()
    var data:[ApiMovie] = []
    @Injected(\.storage) private var storage: MovieStorage
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        searchBar.delegate = self
        self.registerTableViewCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
 extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            cell.movie = data[indexPath.row]
            cell.poster.image = Movies.imageArray.Images[data[indexPath.row].title]?.posterImage
            cell.title.text = cell.movie?.title
            cell.genre.text = cell.movie?.getGenres()
            cell.year.text = cell.movie?.release_date
            cell.poster.image = Movies.imageArray.Images[data[indexPath.row].title]?.posterImage
            cell.duration.text = String(Movies.imageArray.Images[data[indexPath.row].title]?.runtime ?? 0) + " minutes"
            if storage.exist(record: cell.movie!){
                cell.movie?.isFavorite = true
                cell.favorite.setImage(UIImage(systemName: "star.fill")!, for: .normal)
            }
            else{
                cell.movie?.isFavorite = false
                cell.favorite.setImage(UIImage(systemName: "star")!, for: .normal)
            }
            cell.posterSelected = {
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
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
}

extension SearchViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        data = []
        tableView.reloadData()
        if searchText.count >= 3{
            
            let searchedMovie = { (movies: [ApiMovie]) in
              for mov in movies {
                  self.data.append(mov)
                  let loadImage = MovieDetail(movie: mov)
                  loadImage.load(string: "https://image.tmdb.org/t/p/original\(mov.poster_path ?? "")")
                  loadImage.loadDetails()
                  Movies.imageArray.Images[mov.title] = loadImage
              }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
              }
            }
            
            self.c.fetchSearchedMovies(searchString: searchText, completion: searchedMovie)
        }
    }
}




