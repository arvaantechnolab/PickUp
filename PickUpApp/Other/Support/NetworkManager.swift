//
//  NetworkManager.swift
//  Knitd
//
//  Created by arvaan on 7/6/17.
//  Copyright © 2017 Arvaan. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import SVProgressHUD

final class NetworkManager: NSObject {

    static var shared : NetworkManager = sharedManager()
    private static var showLog = false
    
    static func sharedManager() -> NetworkManager {
        
        let sharedInstance = NetworkManager()
        return sharedInstance
    }
    
    func requestWithMethodType(_ method: HTTPMethod, url : String, parameters: Parameters?, responseKey : String = Response.data, successHandler: @escaping (_ response:Any)->(), failureHandler: @escaping (_ errorMessage : String)->()){
        
        //If Internet is not Reachable
        if(MTReachabilityManager.isReachable() == false) {
            
            failureHandler(WebServiceCallErrorMessage.ErrorInternetConnectionNotAvailableMessage)
            return
        }
        if (NetworkManager.showLog) {
            print("url \(url)")
            print("parameters\n \(self.paramterString(parameters))")
            print("Header\n \(self.paramterString(Header.createHeader()))")
        }

        Alamofire.request(url, method: method, parameters: parameters,
                                                encoding: URLEncoding.httpBody,
                                                headers: Header.createHeader()).responseJSON(completionHandler: { (response) in
            
            
            if (NetworkManager.showLog) {
                print("respnse \(response.data?.toString)")
            }
            switch response.result {
                
            case .success(let result):
                
                if let resultDict = result as? [String:Any]{
                    if let statusCode = resultDict[Response.status_code] as? Int{
                        
                        if statusCode == 200{
                            if responseKey == Response.data {
                                successHandler((result as! [String:Any])[Response.data])
                            }
                            else{
                                successHandler((result as! [String:Any])[Response.message])
                            }
                            
                        }
                        else{
                            
                            if(statusCode == 504){
//                                AppDelegate.sharedAppDelegate.sessionExpired()
                            }
                            
                            if let message = resultDict[Response.message] as? String{
                                failureHandler(message)
                            }
                        }
                    }
                }
                break
                
            case .failure(let error):
                
                //     print("response \(response.data?.toString)")
                failureHandler(error.localizedDescription)
                break
            }
        })
    }
    
    func multipartRequestWithMethodType(_ method: HTTPMethod, url : String, parameters: Parameters?, successHandler: @escaping (_ response:Any)->(), progressHandler: @escaping (_ progress : Float)->() ,failureHandler: @escaping (_ errorMessage : String)->()) -> Request?{
        
        //If Internet is not Reachable
        if(MTReachabilityManager.isReachable() == false) {
            
            failureHandler(WebServiceCallErrorMessage.ErrorInternetConnectionNotAvailableMessage)
            return nil
        }
        
        if (NetworkManager.showLog) {
            print("url \(url)")
            print("\nparameters\n \(self.paramterString(parameters))")
            print("\nHeader\n \(self.paramterString(Header.createHeader()))")
        }
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            

            for (key, value) in parameters! {
                
                if value is String {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if value is UIImage {
                    
                    let imgData = UIImageJPEGRepresentation(value as! UIImage, 1)!
                    multipartFormData.append(imgData, withName: key ,fileName: "file.jpg", mimeType: "image/jpg")
                }
                
                
                if value is Array<UIImage> {
                    let arrayValue = value as! [UIImage]
                    
                    for image in arrayValue {
                        
                  //      print("image upload for key  \(key)")
                        
                        let fileName = "file\(arc4random()%1000).jpg"
                        let mimeType = fileName.mimeTypeForPath ?? "image/jpg"
                        let data = UIImageJPEGRepresentation(image, 1)
                        
                        multipartFormData.append(data!, withName: "\(key)", fileName:fileName, mimeType: mimeType)
                    }
                    
                }
                
            }
        },to:url,method: .post,  headers: Header.createHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    progressHandler(Float(progress.fractionCompleted))
                })
                
                upload.responseJSON { response in
                    if (NetworkManager.showLog) {
                        print("respnse \(response.data?.toString)")
                    }

                    switch response.result {
                        
                    case .success(let result):
                        
                        if let resultDict = result as? [String:Any]{
                            if let statusCode = resultDict[Response.status_code] as? Int{
                                
                                if statusCode == 200{
                                    let res = (result as! [String:Any])[Response.data]!
                                    print("result \(res)")
                                    successHandler(res)
                                }else{
                                    if let message = resultDict[Response.message] as? String{
                                        failureHandler(message)
                                    }
                                }
                            }
                        }
                        break
                        
                    case .failure(let error):
                        failureHandler(error.localizedDescription)
                        break
                    }

                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        return nil;
    }
    
    func requestAddress(_ method: HTTPMethod, url : String, parameters: Parameters?, successHandler: @escaping (_ response:Any)->(), failureHandler: @escaping (_ errorMessage : String)->()){
        
        //If Internet is not Reachable
        if(MTReachabilityManager.isReachable() == false) {
            
            failureHandler(WebServiceCallErrorMessage.ErrorInternetConnectionNotAvailableMessage)
            return
        }
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let result):
                
                if let resultDict = result as? [String:Any]{
                    if let result = resultDict[Response.result] as? [[String:Any]]{
                        
                        if result.count > 0{
                            successHandler(result)
                            
                        }else{
                            failureHandler("Fails to fetch address")
                        }
                    }
                }
                break
                
            case .failure(let error):
                failureHandler(error.localizedDescription)
                break
            }
        })
    }
    
    static func cancelAllTask(){
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            
            dataTasks.forEach {
                print("dataTasks \($0.originalRequest?.url)")
                $0.cancel()
            }
            
            uploadTasks.forEach {
                print("uploadTasks \($0.originalRequest?.url)")
                $0.cancel()
            }
            
            downloadTasks.forEach {
                print("downloadTasks \($0.originalRequest?.url)")
                $0.cancel()
            }
        }
    }
    
    func paramterString(_ parameter : [String:Any]?) -> String {

        if parameter == nil {
            return "There is no parameter"
        }
        
        var strParameter = ""
        
        for (key, value) in parameter! {
            
            if value is String {
                strParameter += "\n\(key) : \(value)"
            }
            if value is UIImage {
                strParameter += "\n\(key) : \(value)"
            }
            if value is Array<UIImage> {
                strParameter += "\n\(key) : Element \(value)"
            }
        }
        return strParameter
    }
    
    func queryString(_ parameter : [String:Any]?) -> String {
        
        if parameter == nil {
            return ""
        }
        
        var arrQuery:[String] = []
        
        for (key, value) in parameter! {
            
            if value is String {
                arrQuery.append("\(key)=\(value)")
            }
            
        }
        return arrQuery.joined(separator: "&")
    }
    
    
    static func showNetworkLog() {
        showLog = true
    }
    
    static func hideNetworkLog() {
        showLog = false
    }
}
