//
//  CommentsCell.swift
 import UIKit
import Kingfisher

class CommentsCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var viewSeparator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(commentModel: CommentsModel) {
        self.nameLabel.text = commentModel.user?.name ?? " "
        self.commentLabel.text = commentModel.comment_text
        self.timeLabel.text = Utility.dateFormatterWithFormat(commentModel.created_at ?? "", withFormat: DateFormats.DateTime.rawValue)
        if let userDetail = commentModel.user?.details, let userImage = userDetail.image_url {
            self.userImage.kf.setImage(with: URL(string: userImage),placeholder: UIImage(named: "profile_placeholder"))
        }
        self.setUI(user_id: commentModel.user_id ?? 0)
    }
    func setUI(user_id:Int){
        if user_id == (AppStateManager.sharedInstance.userData?.user?.id ?? 0){
            self.btnEdit.isHidden = false
            self.btnDelete.isHidden = false
            self.viewSeparator.isHidden = false
        }
        else{
            self.btnEdit.isHidden = true
            self.btnDelete.isHidden = true
            self.viewSeparator.isHidden = true
        }
    }
}
