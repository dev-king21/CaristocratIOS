//
//  LuxuryMarket.swift
 import Foundation

extension APIManager {
    
    func getCountries(success:@escaping ([Region]) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.Countries.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [Region].self, failure: failure, errorPopup: true)
    }
    
    func saveRegions(regionsId: [Int],
                     success:@escaping (DefaultResponse) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let params: [String: Any] = ["region_id": regionsId]
        
        let route: URL = POSTURLforRoute(route: Route.SaveRegions.rawValue)!
        self.postRequestWith(route: route, parameters: params, success: success, responseType: DefaultResponse.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    func getVehicles(params: Parameters,
                    success:@escaping ([VehicleBase]) -> Void,
                    failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.GetVehiclesV2.rawValue)!
        self.getRequestWith(route: route, parameters: params, success: success, responseType: [VehicleBase].self, failure: failure, errorPopup: true)
    }
    
    func getVehiclesWithPaging(params: Parameters,showLoader: Bool = true,
                     success:@escaping ([VehicleBase]) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.GetVehiclesV2.rawValue)!
        
        self.getRequestWithPagination(route: route, parameters: params, success: success, responseType: [VehicleBase].self, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func getVehiclesDetail(carId: Int,
                     success:@escaping (VehicleBase) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.GetVehicles.rawValue + "/\(carId)")!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: VehicleBase.self, failure: failure, errorPopup: true)
    }
    
    func getVehiclesDetailBySlug(slugId: String,
                           success:@escaping (VehicleBase) -> Void,
                           failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.GetVehicles.rawValue + "/\(slugId)")!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: VehicleBase.self, failure: failure, errorPopup: true)
    }
    
//    func getCarModels(brandId: Int,
//                      success:@escaping ([CarModel]) -> Void,
//                      failure:@escaping DefaultAPIFailureClosure) {
//        
//        let route: URL = GETURLfor(route: Route.GetCarModels.rawValue)!
//        
//        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [CarModel].self, failure: failure, errorPopup: true)
//    }
    
}
