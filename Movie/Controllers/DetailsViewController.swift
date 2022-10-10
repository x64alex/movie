import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var starLabel: UIButton!
    @IBOutlet weak var overview: UILabel!

    @IBOutlet weak var actors: UILabel!
    
    @IBOutlet weak var directtors: UILabel!
    @IBOutlet weak var producers: UILabel!
    @IBOutlet weak var genreYearDuration: UILabel!
    
    
    @IBOutlet weak var firstTrailer: UILabel!
    @IBOutlet weak var firstTrailerArrow: UIButton!
    @IBOutlet weak var secondTrailer: UILabel!
    @IBOutlet weak var secondTrailerArrow: UIButton!
    var movie:ApiMovie?
    @Injected(\.storage) private var storage: MovieStorage

    
    @IBAction func firstTrailerPressed(_ sender: UIButton)
    {
        let key = Movies.imageArray.Images[movie!.title]?.trailers[0].key
        if let url = URL(string: "https://www.youtube.com/watch?v=\(key ?? "")") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func secondTrailerPressed(_ sender: UIButton)
    {
        let key = Movies.imageArray.Images[movie!.title]?.trailers[1].key
        if let url = URL(string: "https://www.youtube.com/watch?v=\(key ?? "")") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func starPressed(_ sender: UIButton) {
        self.movie?.isFavorite?.toggle()

        setButtonBackGround(view: sender, on: UIImage(systemName: "star.fill")!, off: UIImage(systemName: "star")!, onOffStatus: self.movie!.isFavorite ?? false)
    
    }
    @IBAction func sharePressed(_ sender: UIButton) {
        guard let image = poster.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mov = movie{
            movieTitle.text = mov.title
            movieTitle.numberOfLines = 0
            poster.image = Movies.imageArray.Images[mov.title]?.posterImage
            poster.transform = CGAffineTransform(scaleX: 4, y: 1)

            poster.clipsToBounds = true
            genreYearDuration.text = (movie?.getGenres())!+" - "+String((movie?.release_date)!.prefix(4))+" - "+String(Movies.imageArray.Images[mov.title]?.runtime ?? 0) + "minutes"
            overview.text = mov.overview
            overview.numberOfLines = 10
            
            let actorsArray = Movies.imageArray.Images[mov.title]?.actors
            var actorsText = ""
            for actorItem in actorsArray!
            {
                actorsText += actorItem+"\n"
            }
            actors.text = actorsText
            actors.numberOfLines = 0
            
            let directorsArray = Movies.imageArray.Images[mov.title]?.directors
            var directorText = ""
            for director in directorsArray!
            {
                directorText += director+"\n"
            }
            directtors.text = directorText
            directtors.numberOfLines = 0
            
            
            let producersArray = Movies.imageArray.Images[mov.title]?.producers
            var producerText = ""
            for producer in producersArray!
            {
                producerText += producer+"\n"
            }
            producers.text = producerText
            producers.numberOfLines = 0
            
            let trailers = Movies.imageArray.Images[mov.title]?.trailers
            if trailers!.count < 2{
                secondTrailer.text = ""
                secondTrailerArrow.isHidden = true
                
                if trailers!.count==0
                {
                    firstTrailer.text = ""
                    firstTrailerArrow.isHidden = true
                }
                else
                {
                    firstTrailer.text = trailers![0].name
                    firstTrailer.numberOfLines = 0
                }
            }
            else{
                secondTrailer.text = trailers![1].name
                secondTrailer.numberOfLines = 0
            }

            
            
            if storage.exist(record: mov){
                starLabel.setImage(UIImage(systemName: "star.fill")!, for: .normal)
            }
            else{
                starLabel.setImage(UIImage(systemName: "star")!, for: .normal)
            }
            
        }
    }
    func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
        case true:
            view.setImage(on, for: .normal)
            storage.save(record: movie!)
        default:
            view.setImage(off, for: .normal)
            storage.delete(record: movie!)
        }
        
    }
}
