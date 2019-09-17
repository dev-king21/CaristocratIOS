//
//  RangingCell.swift
 import UIKit
import RangeSeekSlider

class RangingCell: UITableViewCell {
    
    @IBOutlet weak var priceView: UIView?
    @IBOutlet weak var modelYearView: UIView?
    @IBOutlet weak var budgetView: UIView?
    @IBOutlet weak var mileageView: UIView?
    @IBOutlet weak var priceSeek: RangeSeekSlider?
    @IBOutlet weak var modelYearSeek: RangeSeekSlider?
    @IBOutlet weak var budgetSeek: RangeSeekSlider?
    @IBOutlet weak var mileageSeek: RangeSeekSlider?
    @IBOutlet weak var priceRangeLabel: UILabel?
    @IBOutlet weak var modelYearRangeLabel: UILabel?
    @IBOutlet weak var budgetRangeLabel: UILabel?
    @IBOutlet weak var mileageRangeLabel: UILabel?
    
    var slug = Slugs.LUXURY_MARKET

    override func awakeFromNib() {
        super.awakeFromNib()
     
        
    }
    
    func setData() {
        self.customizeAppearance()
    }
    
    func customizeAppearance() {
        self.setSeeksDelegate()
        self.setRanging()
        self.seeksApperance()
    }
    
    func seeksApperance() {
        priceView?.isHidden = true
        modelYearView?.isHidden = true
        budgetView?.isHidden = true
        mileageView?.isHidden = true
        
        switch slug {
            case .LUXURY_MARKET:
                 budgetView?.isHidden = false
                break
            case .THE_OUTLET_MALL:
                priceView?.isHidden = false
                modelYearView?.isHidden = false
                break
            case .APPROVED_PRE_OWNED, .CLASSIC_CARS:
                priceView?.isHidden = false
                modelYearView?.isHidden = false
                mileageView?.isHidden = false
                break
            default:
                break
        }
    }
    
    func setSeeksDelegate() {
        priceSeek?.delegate = self
        modelYearSeek?.delegate = self
        mileageSeek?.delegate = self
        budgetSeek?.delegate = self
    }
    /*
     if slider.tag == 10 {
     priceRangeLabel?.text = "AED \(Int(minValue).withCommas()) - AED \(Int(maxValue).withCommas())"
     } else if slider.tag == 20 {
     modelYearRangeLabel?.text = "\(Int(minValue)) - \(Int(maxValue))"
     } else if slider.tag == 30 {
     mileageRangeLabel?.text = "\(Int(minValue).withCommas()) KM - \(Int(maxValue).withCommas()) KM"
     } else if slider.tag == 40 {
     budgetRangeLabel?.text = "AED \(Int(minValue).withCommas()) - AED \(Int(maxValue).withCommas())"
     }
     
     */
    
    
    func setRanging() {
        
        if slug == Slugs.CLASSIC_CARS {
            modelYearSeek?.minValue = 1920
            modelYearSeek?.maxValue = 2010
            modelYearSeek?.selectedMinValue = 1920
            modelYearSeek?.selectedMaxValue = 2010
        }
        
        var min_price = 0
        var max_price = 0
        if let minPrice = AppStateManager.sharedInstance.filterOptions?.min_price {
            priceSeek?.selectedMinValue = CGFloat(minPrice)
            min_price = minPrice
        } else {
            priceSeek?.selectedMinValue = priceSeek?.minValue ?? 0
            min_price = Int(priceSeek?.minValue ?? 0)
        }
        
        if let maxPrice = AppStateManager.sharedInstance.filterOptions?.max_price {
            priceSeek?.selectedMaxValue = CGFloat(maxPrice)
            max_price = maxPrice
        }  else {
            priceSeek?.selectedMaxValue = priceSeek?.maxValue ?? 0
            max_price = Int(priceSeek?.maxValue ?? 0)
        }
        
        priceRangeLabel?.text = "AED \(min_price.withCommas()) - AED \(max_price.withCommas())"
        
        priceSeek?.setNeedsLayout()
        
        var min_year = 0
        var max_year = 0
        if let minYear = AppStateManager.sharedInstance.filterOptions?.min_model_year {
            modelYearSeek?.selectedMinValue = CGFloat(minYear)
            min_year = minYear
        } else {
            modelYearSeek?.selectedMinValue = modelYearSeek?.minValue ?? 0
            min_year = Int(modelYearSeek?.minValue ?? 0)
        }
        
        if let maxYear = AppStateManager.sharedInstance.filterOptions?.max_model_year {
            modelYearSeek?.selectedMaxValue = CGFloat(maxYear)
            max_year = maxYear
        }  else {
            modelYearSeek?.selectedMaxValue = modelYearSeek?.maxValue ?? 0
            max_year = Int(modelYearSeek?.maxValue ?? 0)
        }
        modelYearRangeLabel?.text = "\(min_year) - \(max_year)"
        modelYearSeek?.setNeedsLayout()
        
        var min_budget_price = 0
        var max_budget_price = 0
        if let min_price = AppStateManager.sharedInstance.filterOptions?.min_price {
            budgetSeek?.selectedMinValue = CGFloat(min_price)
            min_budget_price = min_price
        } else {
            budgetSeek?.selectedMinValue = budgetSeek?.minValue ?? 0
            min_budget_price = Int(budgetSeek?.minValue ?? 0)
        }
        
        if let max_price = AppStateManager.sharedInstance.filterOptions?.max_price {
            budgetSeek?.selectedMaxValue = CGFloat(max_price)
            max_budget_price = max_price
        }  else {
            budgetSeek?.selectedMaxValue = budgetSeek?.maxValue ?? 0
            max_budget_price = Int(budgetSeek?.maxValue ?? 0)
        }
        budgetRangeLabel?.text = "AED \(min_budget_price.withCommas()) - AED \(max_budget_price.withCommas())"
        budgetSeek?.setNeedsLayout()

        var min_mile_age = 0
        var max_mile_age = 0
        if let min_mileage = AppStateManager.sharedInstance.filterOptions?.min_mileage {
            mileageSeek?.selectedMinValue = CGFloat(min_mileage)
            min_mile_age = min_mileage
        } else {
            mileageSeek?.selectedMinValue = mileageSeek?.minValue ?? 0
            min_mile_age = Int(mileageSeek?.minValue ?? 0)
        }
        
        if let max_mileage = AppStateManager.sharedInstance.filterOptions?.max_mileage {
            mileageSeek?.selectedMaxValue = CGFloat(max_mileage)
            max_mile_age = max_mileage
        }  else {
            mileageSeek?.selectedMaxValue = mileageSeek?.maxValue ?? 0
            max_mile_age = Int(mileageSeek?.maxValue ?? 0)
        }
        
        mileageRangeLabel?.text = "\(min_mile_age.withCommas()) KM - \(max_mile_age.withCommas()) KM"
        mileageSeek?.setNeedsLayout()
    }
}

extension RangingCell : RangeSeekSliderDelegate {
    func didEndTouches(in slider: RangeSeekSlider) {
        if slider.tag == 10 {
            AppStateManager.sharedInstance.filterOptions?.min_price = Int(slider.selectedMinValue)
            AppStateManager.sharedInstance.filterOptions?.max_price = Int(slider.selectedMaxValue)
            
        } else if slider.tag == 20 {
            AppStateManager.sharedInstance.filterOptions?.min_model_year = Int(slider.selectedMinValue)
            AppStateManager.sharedInstance.filterOptions?.max_model_year = Int(slider.selectedMaxValue)
        } else if slider.tag == 30 {
            AppStateManager.sharedInstance.filterOptions?.min_mileage = Int(slider.selectedMinValue)
            AppStateManager.sharedInstance.filterOptions?.max_mileage = Int(slider.selectedMaxValue)
        } else if slider.tag == 40 {
            AppStateManager.sharedInstance.filterOptions?.min_price = Int(slider.selectedMinValue)
            AppStateManager.sharedInstance.filterOptions?.max_price = Int(slider.selectedMaxValue)
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider.tag == 10 {
            priceRangeLabel?.text = "AED \(Int(minValue).withCommas()) - AED \(Int(maxValue).withCommas())"
        } else if slider.tag == 20 {
            modelYearRangeLabel?.text = "\(Int(minValue)) - \(Int(maxValue))"
        } else if slider.tag == 30 {
            mileageRangeLabel?.text = "\(Int(minValue).withCommas()) KM - \(Int(maxValue).withCommas()) KM"
        } else if slider.tag == 40 {
            budgetRangeLabel?.text = "AED \(Int(minValue).withCommas()) - AED \(Int(maxValue).withCommas())"
        }
    }
    
}
