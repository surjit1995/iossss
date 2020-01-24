

import UIKit

class ListDetailCell: UITableViewCell {

    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var countryTxt: UILabel!
    @IBOutlet weak var genderTxt: UILabel!
    @IBOutlet weak var birthdayTxt: UILabel!
    @IBOutlet weak var latitudeTxt: UILabel!
    @IBOutlet weak var longitudeTxt: UILabel!

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView?.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
