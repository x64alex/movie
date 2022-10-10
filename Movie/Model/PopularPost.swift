import UIKit

struct ApiMovie: Codable {
    let adult:Bool
    let backdrop_path:String?
    let genre_ids:[Int]
    let id:Int
    let original_language:String
    let original_title:String
    let overview:String
    let popularity:Float
    let poster_path:String?
    let release_date:String
    let title:String
    let video:Bool
    let vote_average:Double
    let vote_count:Int
    var isFavorite:Bool? = nil
}

extension ApiMovie{
    func getGenres()->String{
        let genreList:[Int:String] = [28:"Action",12:"Adventure",16:"Animation",35:"Comedy",80:"Crime",99:"Documentary",18:"Drama",10751:"Family",14:"Fantasy",36:"History",27:"Horror",10402:"Music",9648:"Mystery",10749:"Romance",878:"Science Fiction",10770:"TV Movie",53:"Thriller",10752:"War",37:"Western"]
        var genre = ""
        for gen in self.genre_ids{
            genre += genreList[gen]!+" "
        }
        if genre_ids.isEmpty{
            return "No genre found on api"
        }
        return genreList[genre_ids[0]]!
    }
}

class MovieDetail{
    var posterImage:UIImage? = nil
    var movie:ApiMovie
    var runtime:Int?
    var actors:[String] = []
    var directors:[String] = []
    var producers:[String] = []
    var trailers:[Trailer] = []
    
    init(movie:ApiMovie) {
        self.movie = movie
    }
    func load(string: String) {
        if URL(string: string) == nil{
            print(1)
            return
        }
        DispatchQueue.global().async { [self] in
            if let data = try? Data(contentsOf: URL(string: string)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.global().async {
                        self.posterImage = image
                    }
                }
            }
        }
    }
    func loadDetails(){
        closure.fetch.fetchDetailMovie(movieId: movie.id) { movie in
            self.runtime = movie.runtime
        }
        closure.fetch.fetchCreditMovie(movieId: movie.id) { movie in
            for cast in movie.cast
            {
                if cast.known_for_department == "Acting"{
                    if !self.actors.contains(cast.name)
                    {
                        self.actors.append(cast.name)
                    }
                }
            }
            for crewMember in movie.crew{
                if crewMember.known_for_department == "Production"{
                    if !self.producers.contains(crewMember.name){
                        self.producers.append(crewMember.name)
                    }
                }
                if crewMember.known_for_department == "Directing"{
                    if !self.directors.contains(crewMember.name)
                    {
                        self.directors.append(crewMember.name)
                    }
                }
            }
        }
        closure.fetch.fetchVideosMovies(movieId: movie.id) { (trailer:[Trailer]) in
            for trail in trailer {
                if trail.type == "Trailer"{
                    self.trailers.append(trail)
                }
            }
        }
    }
}

class Movies{
    var Images:[String:MovieDetail] = [:]
    static let imageArray = Movies()
    
}

struct Post:Codable{
    let page:Int
    let results:[ApiMovie]
    let total_pages:Int
    let total_results:Int
}

struct Dates:Codable{
    let maximum:String
    let minimum:String
}

struct UpcomigPost:Codable{
    let dates:Dates
    let page:Int
    let results:[ApiMovie]
    let total_pages:Int
    let total_results:Int
}

struct DetailMovie:Codable{
    var runtime:Int?
}

struct Cast:Codable
{
    var name:String
    var known_for_department:String
}

struct Crew:Codable
{
    var name:String
    var known_for_department:String
}

struct MovieCredits:Codable
{
    let cast:[Cast]
    let crew:[Crew]
}

struct Trailer:Codable
{
    let key:String
    let name:String
    let type:String?
}

struct Video:Codable
{
    let results:[Trailer]
}

class closure{
    //api key = 22547df3e60a130ab6eb2cb6c2134881
    // https://image.tmdb.org/t/p/original/wuMc08IPKEatf9rnMNXvIDxqP4W.jpg
    static let fetch = closure()
    
    func fetchPopularMovies(completion: @escaping ([ApiMovie]) -> ()) {
      let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US&page=1"
      let url = URL(string: urlString)!
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
          print("data was nil")
          return
        }
        do {
          let movie = try JSONDecoder().decode(Post.self, from: data)
         DispatchQueue.global().async {
             completion(movie.results)
             //print(movie.results)
          }
        } catch {
          print("fetchRandomImages: \(error)")
        }
      }
      task.resume()
    }
    
    func fetchUpcomigMovies(completion: @escaping ([ApiMovie]) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US&page=1"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(UpcomigPost.self, from: data)
            DispatchQueue.global().async {
               completion(movie.results)
               //print(movie.results)
            }
          } catch {
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
    
    func fetchTopRatedMovies(completion: @escaping ([ApiMovie]) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US&page=1"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(Post.self, from: data)
            DispatchQueue.global().async {
               completion(movie.results)
               //print(movie.results)
            }
          } catch {
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
    
    func fetchSearchedMovies(searchString:String,completion: @escaping ([ApiMovie]) -> ()) {
        let newSearchString = searchString.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US&query=\(newSearchString)&page=1&include_adult=false"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(Post.self, from: data)
            DispatchQueue.global().async {
               completion(movie.results)
               //print(movie.results)
            }
          } catch {
              print(urlString)
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
    
    func fetchDetailMovie(movieId:Int,completion: @escaping (DetailMovie) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(DetailMovie.self, from: data)
            DispatchQueue.global().async {
               completion(movie)
            }
          } catch {
              print(urlString)
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
    func fetchCreditMovie(movieId:Int,completion: @escaping (MovieCredits) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(MovieCredits.self, from: data)
            DispatchQueue.global().async {
                //  print(movie)
               completion(movie)
            }
          } catch {
              print(urlString)
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
    func fetchVideosMovies(movieId:Int,completion: @escaping ([Trailer]) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          do {
            let movie = try JSONDecoder().decode(Video.self, from: data)
            DispatchQueue.global().async {
                completion(movie.results)
            }
          } catch {
            print("fetchRandomImages: \(error)")
          }
        }
        task.resume()
      }
}
