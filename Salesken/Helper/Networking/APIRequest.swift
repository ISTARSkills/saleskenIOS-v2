//
//  APIRequest.swift
//  Salesken
//
//  Created by Anup on 13/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import Foundation

public class APIRequest {
    
    //GET Api
    class func getRequest(_ url:String, success: @escaping (Data) -> Void,failure: @escaping (String) -> Void){
        let sharedSession = URLSession.shared
        if let apiURL = URL(string: url) {
            let request = URLRequest(url: apiURL)
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if error != nil || data == nil {
                    failure(error!.localizedDescription)
                    return
                }
                if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                    failure("Server error status code \(response.statusCode)")
                    return
                }
                if let data = data {
                    success(data)
                }
            })
            dataTask.resume()
        }
    }
    
    //POST Api
    class func postRequest(_ params: [String:String],url:String, success: @escaping (Data) -> Void,failure: @escaping (String) -> Void){
        let sharedSession = URLSession.shared
        if let apiURL = URL(string: url) {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
            request.httpBody = data
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if error != nil || data == nil {
                    failure(error!.localizedDescription)
                    return
                }
                if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                    failure("Server error status code \(response.statusCode)")
                    return
                }
                if let data = data {
                    success(data)
                }
            })
            dataTask.resume()
            
        }
    }
}
