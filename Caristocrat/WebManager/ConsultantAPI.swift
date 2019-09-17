//
//  ConsultantAPI.swift
 import Foundation

extension APIManager {

    func getRateFields(success:@escaping ([RateFieldsModel]) -> Void,
                      failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.ReviewFields.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [RateFieldsModel].self, failure: failure, errorPopup: true)
    }
    
    func getReviews(carId: Int,
                    success:@escaping ([ReviewModel]) -> Void,
                    failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.Reviews.rawValue)!
        self.getRequestWith(route: route, parameters: ["car_id":carId], success: success, responseType: [ReviewModel].self, failure: failure, errorPopup: true)
    }
    
    func submitReview(params: Parameters,
                      success:@escaping (Bool) -> Void,
                      failure:@escaping DefaultAPIFailureClosure) {

        let route: URL = POSTURLforRoute(route: Route.Reviews.rawValue)!
//        self.postRequestWith(route: route, parameters: params, success: success, responseType: DefaultResponse.self, failure: failure, errorPopup: true)
        self.postRequestWith(route: route, parameters: params, onResponse: success)
    }
    

}
