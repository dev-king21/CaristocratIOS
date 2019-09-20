//
//  CompareCarController.swift
 import UIKit
import DZNEmptyDataSet

protocol CompareCarSubDelegates {
    func didCarSelected(vehicleDetail: VehicleBase)
}

class CompareCarSubController: BaseViewController {

    @IBOutlet weak var segmentImage: UIImageView!
    @IBOutlet weak var segmentName: UILabel!
    @IBOutlet weak var compareBySubSegmentView: CompareBySubSegmentView!
    
    var segment: BodyStyleModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentName.text = segment.name?.uppercased() ?? ""
        self.segmentImage.kf.setImage(with: URL(string: segment.un_selected_icon ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        compareBySubSegmentView.setBodyStyleData(data: segment)
    }
    
}

