//
//  RangeSeekBarTVC.swift
 import UIKit

struct SliderValues{
    var name = ""
    var startValue = "0"
    var endValue = "0"
    var computedValue = "0"
    var unit = ""
}

class RangeSeekBarTVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStartValue: UILabel!
    @IBOutlet weak var lblEndvalue: UILabel!
    @IBOutlet weak var lblComputedvalue: UILabel!
    @IBOutlet weak var lblComputedAmount: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var computedValueLeading: NSLayoutConstraint!
    @IBOutlet weak var computedAmountLeading: NSLayoutConstraint!
    
    func setData(data:SliderValues, isMonth: Bool = false){
        self.lblName.text = data.name
        self.lblStartValue.text = data.startValue + " " + data.unit
        self.lblEndvalue.text = data.endValue + " " + data.unit
        self.lblComputedvalue.text = (!isMonth ? (Double(data.computedValue)?.decimalPoints() ?? "").description : data.computedValue)  + " " + data.unit
        
        guard let startValue = Float(data.startValue) else {return}
        guard let endValue = Float(data.endValue) else {return}
        guard let computedValue = Float(data.computedValue) else {return}
        
        self.slider.minimumValue = startValue
        self.slider.maximumValue = endValue
        
        self.slider.value = computedValue
        
        let trackRect = self.slider.trackRect(forBounds: self.slider.frame)
        let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: self.slider.value)
        let textWidth = (data.computedValue + " " + data.unit).size(withAttributes: nil).width
        self.computedValueLeading.constant = thumbRect.minX - (textWidth/2)
        self.computedAmountLeading.constant = thumbRect.minX - (textWidth/2)
    }
}
