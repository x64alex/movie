import UIKit

class CustomTableViewCell: UITableViewCell {
    var movie: ApiMovie? = nil
    var posterSelected: (() -> Void)? = nil
    var onStarDeselected: (() -> Void)? = nil
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func clickPoster() {
        posterSelected?()
    }

    @IBAction func starSelect() {
        self.movie?.isFavorite?.toggle()

        onStarDeselected?()
    }
}
