//
//  AutoLifeCategoryCell.swift
 import UIKit
import AVKit

class CategoryDetailCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    var isForProfile = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(news: NewsModel) {
        
       self.dateLabel.text = Utility.dateFormatterWithFormat(news.created_at ?? "", withFormat: DateFormats.Date.rawValue)
       titleLabel.text = news.headline
       viewsCountLabel.text = (news.views_count ?? 0).description
       favCountLabel.text = (news.like_count ?? 0).description
       commentsCountsLabel.text = (news.comments_count ?? 0).description
       featureLabel.isHidden = !(news.is_featured?.value() ?? false)
       
//        if let media = news.media, media.count > 0 {
//           self.carImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
//       }
        
       if let source = news.media?.first?.file_url {
            if (news.media?.first?.media_type ?? 0) == 10{
                self.carImage.kf.setImage(with: URL(string: source), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            }
            else{
               // let url = URL(string: source)
                //  let youtubeURL = self.getThumbnailImage(forUrl: url!)//Utility.youtubeThumbnail(url: source)
                let youtubeURL = Utility.youtubeThumbnail(url: source)
                print(youtubeURL)
                //  self.carImage.image = youtubeURL
                self.carImage.kf.setImage(with: URL(string: youtubeURL), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        }
        }
        
        heartImage.isHidden = isForProfile ? !(news.is_liked ?? false) : true
        
    }
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
