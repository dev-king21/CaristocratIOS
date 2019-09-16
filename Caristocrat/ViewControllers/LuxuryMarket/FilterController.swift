//
//  FilterController.swift
 import UIKit

protocol FilterCellsDelegate {
    func didTransmissionSelect()
}

protocol FilterControllerDelegate {
     func didTapOnAddBrand()
     func didTapOnApplyFilter()
    func didTapOnClearFilter()
     func didTapOnCountrySelection()
}

extension FilterControllerDelegate {
    func didTapOnClearFilter() {}
}

class FilterController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var cells: [CellWithoutHeight] = [
        (BrandFilterCell.identifier,1),
        (CountryFilterCell.identifier,1),
//        (VersionFilterCell.identifier,1),
        (DealerTypeCell.identifier,1),
        (RangingCell.identifier,1),
        (MinimumRatingCell.identifier,1),
        (BodyStyleCell.identifier,1)]
    
    var delegate: FilterControllerDelegate?
    var slug = Slugs.LUXURY_MARKET
    
    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        
        self.customizeApperence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.none)
    }
    
    func customizeApperence() {
        self.setFilterOptions()
        self.prepareTableview()
    }
    
    func setFilterOptions() {
        if slug == Slugs.LUXURY_MARKET {
            cells = cells.filter({$0.identifier != DealerTypeCell.identifier})
            cells = cells.filter({$0.identifier != CountryFilterCell.identifier})
        } else if slug == Slugs.THE_OUTLET_MALL {
            cells = cells.filter({$0.identifier != BodyStyleCell.identifier})
            cells = cells.filter({$0.identifier != MinimumRatingCell.identifier})
        } else if slug == Slugs.APPROVED_PRE_OWNED {
            cells = cells.filter({$0.identifier != BodyStyleCell.identifier})
            cells = cells.filter({$0.identifier != MinimumRatingCell.identifier})
        } else if slug == Slugs.CLASSIC_CARS {
            cells = cells.filter({$0.identifier != BodyStyleCell.identifier})
            cells = cells.filter({$0.identifier != MinimumRatingCell.identifier})
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBAction func tappedOnClose() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOnApply() {
        delegate?.didTapOnApplyFilter()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOnClear() {
        AlertViewController.showAlert(title: "Clear Filter", description: "Do you want to clear search filter?", rightButtonText: "CLEAR", leftButtonText: "CANCEL", delegate: self)
    }
}


extension FilterController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].identifier)
        
        if let brandFilter = cell as? BrandFilterCell {
            brandFilter.delegate = self
            brandFilter.setData()
        } else if let countryFilterCell = cell as? CountryFilterCell {
            countryFilterCell.delegate = self
            countryFilterCell.setData()
        } else if let transmissionCell = cell as? TransmissionCell {
            transmissionCell.selectTab()
        } else if let rangingCell = cell as? RangingCell {
            rangingCell.slug = slug
            rangingCell.setData()
        } else if let dealerTypeCell = cell as? DealerTypeCell {
            dealerTypeCell.setData()
        } else if let cell = cell as? BodyStyleCell {
            cell.resetSelection()
        } else if let minimumRatingCell = cell as? MinimumRatingCell {
            minimumRatingCell.setData()
        } else if let versionFilterCell = cell as? VersionFilterCell {
            versionFilterCell.setData()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension FilterController: FilterControllerDelegate {
    
    func didTapOnCountrySelection() {
        let countriesViewController = CountrySelectionController.instantiate(fromAppStoryboard: .LuxuryMarket)
        countriesViewController.isForFilter = true
        countriesViewController.delegate = self
        countriesViewController.modalPresentationStyle = .overCurrentContext
        countriesViewController.modalTransitionStyle = .crossDissolve
        present(countriesViewController, animated: true)
    }
    
    func didTapOnApplyFilter() {
        
    }
    
    func didTapOnAddBrand() {
        let brandsController = BrandsController.instantiate(fromAppStoryboard: .LuxuryMarket)
        brandsController.delegate = self
        brandsController.slug = slug.rawValue
        self.navigationController?.pushViewController(brandsController, animated: true)
    }
}

extension FilterController: BrandDelegate {
    func didSelectBrands() {
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.none)
    }
}

extension FilterController: EventPerformDelegate {
    func didActionPerformed(eventName: EventName, data: Any) {
        switch eventName {
            case .didCountrySelected:
               self.tableView.reloadData()
            break
        default:
            break
        }
    }
}
extension FilterController:AlertViewDelegates{
    func didTapOnRightButton() {
        self.clearFilter()
    }
    func didTapOnLeftButton() {}
    func clearFilter(){
        AppStateManager.sharedInstance.clearFilter(withCountry: true)
        //delegate?.didTapOnApplyFilter()
        delegate?.didTapOnClearFilter()
        Utility.showSuccessWith(message: Messages.FilterCleared.rawValue)
        self.tableView.reloadData()
    }
}
