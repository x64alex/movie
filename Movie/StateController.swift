import UIKit
class favouritesState{
    var movies: [Movie] = []
    func addMovie(movie:Movie)
    {
        for mov in movies
        {
            if movie.title == mov.title
            {
                return
            }
        }
        movies.append(movie)
        self.saveData()
    }
    func deleteMovie(movie:Movie)
    {
        var i = 0
        for mov in movies{
            if mov.title == movie.title{
                movies.remove(at: i)
            }
            i+=1
        }
    }
    func existMovie(movie:Movie)->Bool
    {
        for mov in movies{
            if mov.title == movie.title{
                return true
            }
        }
        return false
    }
    func saveData()
    {
        SaveData.saveMovies(movies: self.movies)
    }
    func getData()
    {
        self.movies = SaveData.getMovies()
    }
}
var favouritesMovies = favouritesState()
