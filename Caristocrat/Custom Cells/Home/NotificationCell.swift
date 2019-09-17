//
//  NotificationCell.swift
 import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var ChessisLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(notification: NotificationModel) {
        dateLabel.text = Utility.dateFormatterWithFormat(notification.created_at ?? "", withFormat: "MMM dd, yyyy")
        if "\(notification.action_type ?? 0)" == TradeEvaluateCarType.trade.rawValue {
            nameLabel.text = "Your trade-in request has received an offer"
        } else {
            nameLabel.text = "Your Evaluation request has received an offer"
        }
        modelLabel.text = "Car Title: "+(notification.car_name ?? "")
        ChessisLabel.text = "Chassis: "+(notification.chassis ?? "")
        self.carImage.image = nil
        
        if let image_url = notification.image_url {
            self.carImage.kf.setImage(with: URL(string: image_url), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.carImage.image = UIImage(named: "image_placeholder")
        }
    }
    
}
