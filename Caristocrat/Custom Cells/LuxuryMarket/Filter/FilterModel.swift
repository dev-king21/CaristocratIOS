//
//  FilterModel.swift
 import Foundation

class FilterModel {
    var transmission_type: Int?
    var dealer_type: Int?
    var selectedBrands: [Int:String] = [:]
    var min_price: Int?
    var max_price: Int?
    var min_model_year: Int?
    var max_model_year: Int?
    var min_budget: Int?
    var max_budget: Int?
    var min_mileage: Int?
    var max_mileage: Int?
    var most_viewed: Int?
    var styles: String?
    var selectedModels: [Int: [String : Bool]] = [:] // Bool true when haven't any version in that
    var selectedVersions: [Int: String] = [:]
    var selectedCountries: [Int: String] = [:]
    
    var selectedAllVersion: [Int] = []
    
    var rating: Double?
    var version: String?
}
