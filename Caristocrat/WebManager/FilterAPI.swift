//
//  FilterAPI.swift
 import Foundation

extension APIManager {
    
    func getBodyStyles(success:@escaping ([BodyStyleModel]) -> Void,
                           failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.GetBodyStyles.rawValue)!
        
        self.getRequestWith(route: route, parameters: ["parent_id":0], success: success, responseType: [BodyStyleModel].self, failure: failure, errorPopup: true)
    }
}
