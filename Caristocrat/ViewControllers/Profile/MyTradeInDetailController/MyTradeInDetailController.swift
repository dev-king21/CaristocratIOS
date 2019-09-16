//
//  MyTradeInDetailController.swift
 import UIKit
import ImageSlideshow

class MyTradeInDetailController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cells: [CellWithoutHeight] = [(VehicleImagesCell.identifier,1),
                                      (AboutVehicleCell.identifier,1),
                                      (TopBidCell.identifier,-1),
                                      (ContactInfoCell1.identifier,-1),
                                      (NotFoundCell.identifier, 0)]
    
    let arrHeadings = ["","","Dealers","My Car"]
    
    var vehicleDetail: VehicleBase?
    var myTradeIns: MyTradeIns?
    var refId: Int?
    var images: [KingfisherSource] = []
    var detailType: TradeEvaluateCarType = .trade

    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        
        if myTradeIns == nil {
            getVehicleDetail()
        } else {
            self.customizeApperence()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCarImagesURLs()
    }
    
    func customizeApperence() {
        self.addNotFoundCellIfNeeded()
        self.prepareTableview()
    }
    
    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func getVehicleDetail() {
        APIManager.sharedInstance.getTradeCar(tradeId: refId ?? -1, success: { (result) in
            self.myTradeIns = result
            if self.detailType == .evaluate {
                self.vehicleDetail = self.myTradeIns?.trade_against
            }else{
                self.vehicleDetail = self.myTradeIns?.my_car
            }
            
            self.customizeApperence()
            self.addNotFoundCellIfNeeded()
            self.getCarImagesURLs()
            self.tableView.reloadData()
        }) { (erroor) in
            
        }
    }
    
    func setData() {
        
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func addNotFoundCellIfNeeded() {
        if detailType == .evaluate && self.vehicleDetail?.top_bids?.count == 0 {
            cells[cells.count-1].count = 1
        }
    }
}

extension MyTradeInDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        if let vehicleImagesCell = cell as? VehicleImagesCell, let vehicleDetail = self.vehicleDetail {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSlideShow(sender:)))
            vehicleImagesCell.featureSlideShow.addGestureRecognizer(tapGesture)
            vehicleImagesCell.delegate = self
            vehicleImagesCell.isForTrade = true
            vehicleImagesCell.hideControls()
            vehicleImagesCell.setData(vehicleDetail: vehicleDetail)
        } else if let aboutVehicleCell = cell as? AboutVehicleCell , let vehicleDetail = self.vehicleDetail {
            aboutVehicleCell.setData(vehicleDetail: vehicleDetail, myTradeIn: myTradeIns, forEvaluation: true)
        } else if let topBidCell = cell as? TopBidCell {
            if let offerDetail = self.myTradeIns?.offer_details?[indexPath.row] {
                topBidCell.offerNumberLabel.text = "Offer # \(indexPath.row + 1)"
                topBidCell.setData(carId: self.myTradeIns?.trade_against?.id ?? -1, offerDetail: offerDetail, isExpired: self.myTradeIns?.is_expired ?? false)
            }
        } else if let notFoundCell = cell as? NotFoundCell {
            notFoundCell.setData(text: (self.myTradeIns?.is_expired ?? false) ? "No Offers available." : "Waiting for offer")
        }
        
        
        if indexPath.section == 3 {
            if let contactInfoCell = cell as? ContactInfoCell1 {
                if let tradeCarDetail = self.myTradeIns?.trade_against {
                    contactInfoCell.setData(isMyCar: false, vehicleDetail: tradeCarDetail, amount: self.myTradeIns?.amount ?? 0, myTradeIns: myTradeIns)
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
//            return
            return self.detailType == .evaluate ? ((self.myTradeIns?.is_expired ?? false) ? self.myTradeIns?.offer_details?.count ?? 0 : 0) : self.myTradeIns?.offer_details?.count ?? 0
        } else if detailType == .evaluate && (section == 3) {
            return 0
        } else if cells[section].identifier == NotFoundCell.identifier {
            if self.detailType == .evaluate  && !(self.myTradeIns?.is_expired ?? true) {
                return 1
            } else {
                return (self.myTradeIns?.offer_details?.count ?? 0) > 0 ? 0 : 1
            }
        }

        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = Heading.instanceFromNib() as! Heading
        switch section {
        case 0,1:
            return nil
        case 2:
            if self.detailType == .evaluate {
                headerCell.lblHeading.text = (self.myTradeIns?.offer_details?.count ?? 0 > 0) ? "Here are the top offers for your car." : ""
            } else {
                headerCell.lblHeading.text = "Dealers"
            }
            return headerCell
        case 3:
            if self.detailType == .trade {
              headerCell.lblHeading.text = "My Car"
               return headerCell
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1:
            return 0
        case 2:
            return self.detailType == .evaluate && (self.myTradeIns?.offer_details?.count ?? 0 <= 0) ? 0 : 44
        case 3:
            return detailType == .trade ? 44 : 0
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
}
extension MyTradeInDetailController{
    @objc func didTapOnSlideShow(sender:UIGestureRecognizer){
        if let slideShowView = sender.view as? ImageSlideshow{
            let currentPage = slideShowView.currentPage
            let controller = SlideShow.instantiate(fromAppStoryboard: .Home)
            controller.cur_image_index = currentPage
            controller.ImageSliderArray = self.images
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    func getCarImagesURLs(){
        guard let carImages = self.vehicleDetail?.media else {return}
        self.images.removeAll()
        for carImage in carImages {
            if let source = carImage.file_url {
                if (carImage.media_type ?? 0) == 10 {
                    guard let kingfisherSource = KingfisherSource(urlString:source) else {return}
                    self.images.append(kingfisherSource)
                }
                else{
                    let youtubeURL = Utility.youtubeThumbnail(url: source)
                    guard let kingfisherSource = KingfisherSource(urlString:youtubeURL) else {return}
                    self.images.append(kingfisherSource)
                }
            }
        }
    }
}
extension MyTradeInDetailController: VechicleDetailCellsDelegate {
    func didReviewSubmitted() {
        
    }
    
    func didTapOnSpecsSection(position: Int) {
        
    }
    
    func didTapOnPersonalShopper() {
        
    }
    
    func didTapOnVirtualBuy() {
        
    }
    
    func didDataUpdate() {
        
    }
    
    func didTapOnSimilarListing(vehicles: [VehicleBase], selectedVehicle: VehicleBase) {
        
    }
    
    func didTapOnBack() {
        if let navControlle =  self.navigationController {
            navControlle.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTapOnShare() {
        
    }
    
    func didTapOnTrade() {

    }
}
