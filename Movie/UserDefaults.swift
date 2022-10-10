import Foundation
struct SaveData {
    
    static let (titleKey, genreKey,relaseKey,durationKey,posterKey,descriptionKey,favKey) = ("title", "genreKey","relaseKey","durationKey","posterKey","descriptionKey","favKey")
    private static let userDefault = UserDefaults.standard
    
 
    static func saveMovie(title:String,genre:String="",relase_date:String="",duration:String="",poster:String,description:String="",fav:Bool=false,key:String){
        userDefault.set([titleKey: title, genreKey: genre,relaseKey:relase_date,durationKey:duration,posterKey:poster,descriptionKey:description,favKey:fav],forKey: key)
    }
    static func saveMovies(movies:[Movie]){
        var i=0
        for mov in movies
        {
            self.saveMovie(title: mov.title, genre: mov.genre, relase_date: mov.relase_date, duration: mov.duration, poster: mov.duration, description: mov.description, fav: mov.isFavorite, key: String(i))
            i+=1
        }
    }
    
    static func getMovie(_ key:String) -> Movie?
    {
        let defaults = userDefault.value(forKey: key) as? (title:String,genre:String,relase_date:String,duration:String,poster:String,description:String,fav:Bool) ?? nil
        
        if let defaults = defaults{
            return Movie(title: defaults.title, genre: defaults.genre, relase_date: defaults.relase_date, duration: defaults.duration, poster: defaults.poster, description: defaults.description, fav: defaults.fav)
        }
        else{
            return nil
        }
        
    }
    
    static func getMovies() -> [Movie]
    {
        var mov:[Movie] = []
        
        var i = 0
        while (getMovie(String(i)) != nil){
            mov.append(getMovie(String(i))!)
            i += 1
        }
        
        
        return mov
    }
    
}

protocol Storage {
    associatedtype T

    func save(record: T)
    func load() -> [T]
    func delete(record: T)
}

struct MovieStorage: Storage {
    private enum Key: String {
        case movies = "SavedMovies"
    }
    
    private let userDefaults: UserDefaults
    
    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
    }
    
    func save(record: ApiMovie) {
        var movies = load()
        movies.append(record)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            userDefaults.set(encoded, forKey: Key.movies.rawValue)
        }
    }
    
    func load() -> [ApiMovie] {
        if let moviesData = userDefaults.object(forKey: Key.movies.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let movies = try? decoder.decode([ApiMovie].self, from: moviesData) {
                return movies
            }
        }
        return []
    }
    
    func delete(record: ApiMovie) {
        let movies = load()
            .filter { $0.id != record.id }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            userDefaults.set(encoded, forKey: Key.movies.rawValue)
        }
    }
    
    func exist(record:ApiMovie)->Bool
    {
        let movies = load()
            .filter { $0.id == record.id }
        return movies.count != 0
        
    }
}
