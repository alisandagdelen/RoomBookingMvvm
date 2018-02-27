//
//  DataService.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

typealias GenericObjectBlock<T> = (_ object:T?, _ error: Error?)-> Void
typealias GenericArrayBlock<T> = (_ object:[T]?, _ error: Error?)-> Void

class DataService{
    
    static let sharedInstance = DataService()
    fileprivate init() {}
    
    struct Router: URLRequestConvertible {
        
        var method: Alamofire.HTTPMethod
        var path: String
        let params: [String : Any]?
        
        init(method:Alamofire.HTTPMethod, path:String, params: [String : Any]?) {
            self.method = method
            self.path = path
            self.params = params
        }
        
        
        public func asURLRequest() throws -> URLRequest {
            return urlRequest
        }
        
        var urlRequest: URLRequest {
            let URL = Foundation.URL(string:API.BaseURL + path)!
            
            var req = URLRequest(url:URL)
            req.httpMethod = method.rawValue
            
            do {
                return try Alamofire.JSONEncoding().encode(req, with:params)
            }
            catch{
                return req
            }
        }
        
    }
    
    //MARK: - Service Methods
    
    private func callRequest(_ req:Router) -> DataRequest {
        return Alamofire.request(req).validate()
    }
    
    func postObjectForObject<T:BaseRequest, U:BaseObject>(_ object:T, _ result:@escaping GenericObjectBlock<U>) {
        
        callRequest(Router(method: .post, path: object.url, params: object.toJSON())).responseObject { (response:DataResponse<U>) -> Void in
            if let object = response.result.value {
                result(object, nil)
            } else {
                result(nil, response.result.error)
            }
        }
    }
    
    func postObjectForObjects<T:BaseRequest, U:BaseObject>(_ object:T, _ result:@escaping GenericArrayBlock<U>) {
        
        callRequest(Router(method: .post, path: object.url, params: object.toJSON())).responseArray { (response:DataResponse<[U]>) -> Void in
            if let objects = response.result.value {
                result(objects, nil)
            } else {
                result(nil, response.result.error)
            }
        }
    }
    
}
