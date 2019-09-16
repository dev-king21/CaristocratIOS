//
//  ProfileAPI.swift
 import Foundation

extension APIManager {
    
    func getMyCars(params: Parameters,
                     success:@escaping ([VehicleBase]) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.MyCars.rawValue)!
        self.getRequestWith(route: route, parameters: params, success: success, responseType: [VehicleBase].self, failure: failure, errorPopup: true)
    }
    
    func getTradeInCars(params: Parameters,
                   success:@escaping ([MyTradeIns]) -> Void,
                   failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.TradeInCars.rawValue)!
        self.getRequestWith(route: route, parameters: params, success: success, responseType: [MyTradeIns].self, failure: failure, errorPopup: true)
    }
    
    func getTradeCar(tradeId: Int,
                        success:@escaping (MyTradeIns) -> Void,
                        failure:@escaping DefaultAPIFailureClosure) {

        let route: URL = GETURLfor(route: Route.TradeInCars.rawValue + "/" + tradeId.description)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: MyTradeIns.self, failure: failure, errorPopup: true)
    }
    
    func postTradeInCar(params: Parameters,
                        success:@escaping DefaultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.TradeInCars.rawValue)!
        self.postRequestForDictWith(route: route, parameters: params, success: success, failure: failure, errorPopup: true)
    }
}
