//
//  SimilarVehicleCell.swift
 import UIKit

class SimilarNewsCell: UICollectionViewCell {
   
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(newModel: NewsModel) {
        labelTitle.text = newModel.headline ?? "-"
        
        if let media = newModel.media, media.count > 0 {
            //self.imgCar.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            
            if let source = newModel.media?.first?.file_url {
                if (newModel.media?.first?.media_type ?? 0) == 10{
                    self.imgCar.kf.setImage(with: URL(string: source), placeholder: #imageLiteral(resourceName: "image_placeholder"))
                }
                else{
                    let youtubeURL = Utility.youtubeThumbnail(url: source)
                    print(youtubeURL)
                    self.imgCar.kf.setImage(with: URL(string: youtubeURL), placeholder: #imageLiteral(resourceName: "image_placeholder"))
                }
            }
            
        } else {
            self.imgCar.image = UIImage(named: "image_placeholder")
        }
        

    }
   

}
