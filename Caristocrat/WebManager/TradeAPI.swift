//
//  TradeAPI.swift
 import Foundation
import SwiftyJSON

extension APIManager {
    
    func getBrands(for_comparision: Int,
                   success:@escaping ([Brand]) -> Void,
                   failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetBrands.rawValue)!
        self.getRequestWith(route: route, parameters: ["for_comparision":for_comparision], success: success, responseType: [Brand].self, failure: failure, errorPopup: true)
    }
    
    func getCarModels(brandId: Int,
                      categoryId: Int,
                      for_comparision: Int,
                      success:@escaping ([CarModel]) -> Void,
                      failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetCarModels.rawValue)! 
        let parmas = ["brand_id": brandId, "category_id": categoryId, "for_comparision"  : for_comparision]
        self.getRequestWith(route: route, parameters: parmas, success: success, responseType: [CarModel].self, failure: failure, errorPopup: true)
    }

    func getCarVersion(model_id: Int,
                       success:@escaping ([VersionModel]) -> Void,
                       failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.carVersion.rawValue)!
        let parmas = ["model_id": model_id]
        self.getRequestWith(route: route, parameters: parmas, success: success, responseType: [VersionModel].self, failure: failure, errorPopup: true)
    }
    
    func getRegionalSpecs(success:@escaping ([Regional_specs]) -> Void,
                          failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetRegionalSpecs.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [Regional_specs].self, failure: failure, errorPopup: true)
    }
    
    func getInteriorColors(success:@escaping (CarAttributes) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetCarAttribute.rawValue + "/" + CarAttributeType.InteriorColor.rawValue.description)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: CarAttributes.self, failure: failure, errorPopup: true)
    }
    
    func getExteriorColors(success:@escaping (CarAttributes) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetCarAttribute.rawValue + "/" + CarAttributeType.ExteriorColor.rawValue.description)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: CarAttributes.self, failure: failure, errorPopup: true)
    }
    
    func getAccident(success:@escaping (CarAttributes) -> Void,
                           failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetCarAttribute.rawValue + "/" + CarAttributeType.Accident.rawValue.description)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: CarAttributes.self, failure: failure, errorPopup: true)
    }
    
    func getEngineTypes(success:@escaping ([AttributeOptions]?) -> Void,
                           failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.GetEngineTypes.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [AttributeOptions]?.self, failure: failure, errorPopup: true)
    }
    
    func addCarInTrade(params: Parameters,
                       images: [[String: Any]]?,
                       success:@escaping (VehicleBase) -> Void,
                       failure:@escaping (Error) -> Void,
                       showLoader: Bool = true) {
        
        requestPOSTWithMultipleImages(Constants.BaseURL + Route.MyCars.rawValue, parameters: params, dataImage: images!, success: success, failure: failure )
    }
    
    func editCarInTrade(params: Parameters,
                       images: [[String: Any]]?,
                       success:@escaping (VehicleBase) -> Void,
                       failure:@escaping (Error) -> Void,
                       showLoader: Bool = true) {
        requestPOSTWithMultipleImages(Constants.BaseURL + Route.MyCars.rawValue + "/\(params["id"] ?? 0)", parameters: params, dataImage: images!, success: success, failure: failure )
    }
    
    
    func contactUs(params: Parameters,
                                    success:@escaping (DefaultResponse) -> Void,
                                    failure:@escaping DefaultAPIFailureClosure,
                                    showLoader: Bool = true) {
        
        let route: URL = POSTURLforRoute(route: Route.ContactUs.rawValue)!

        self.postRequestWith(route: route, parameters: params, success: success,responseType: DefaultResponse.self, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func reportListing(carId: Int,
                   reason: String,
                   success:@escaping (DefaultResponse) -> Void,
                   failure:@escaping DefaultAPIFailureClosure,
                   showLoader: Bool = true) {
        
        let route: URL = POSTURLforRoute(route: Route.ReportListing.rawValue)!
        
        self.postRequestWith(route: route, parameters: ["car_id":carId,"message":reason], success: success,responseType: DefaultResponse.self, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func carInteraction(car_id: Int,
                         interactionType: InteractionType,
                         success:@escaping (Bool) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = POSTURLforRoute(route: Route.CarInteractions.rawValue)!
        let params: [String : Any] = ["type": interactionType.rawValue,
                                      "car_id": car_id]
        self.postRequestWith(route: route, parameters: params, success: success,responseType:  Bool.self, failure: failure, errorPopup: true,showLoader: false)
    }
    
}
