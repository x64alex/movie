import UIKit

class Movie:Identifiable {
    var id: String = UUID().uuidString

    let title:String
    var genre:String
    let relase_date:String
    let duration:String
    let description:String
    let poster:String
    var posterImage:UIImage? = nil
    var isFavorite:Bool
    init(title:String,genre:String="",relase_date:String="",duration:String="",poster:String,description:String="",fav:Bool=false) {
        self.title = title
        self.genre = genre
        self.relase_date = relase_date
        self.duration = duration
        self.poster = poster
        self.description = description
        self.isFavorite = fav
    }

    func load(string: String) {
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
}
extension Array where Element == Movie {
    func indexOfMovie(with id: Movie.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
    func contains(id: Movie.ID)->Bool{
        for movie in self{
            if movie.id == id{
                return true
            }
        }
        return false
    }
}
