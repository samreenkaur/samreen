//
//  API.swift
//  Leave Management
//
//  Created by osx on 09/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation


class API
{
    static var shared = API()
        
        //MARK: - GET Request
        //RAW Data
        func get(url:URL,token: String?,success:@escaping ([String:Any]) -> (), failure:@escaping (String) -> ()) {
            
            print("\n\nGET::: \(url)")
            
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            
            if token != nil {
                request.addValue(token!, forHTTPHeaderField: "access_token")
            }
            request.addValue(basicAuthString, forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil{
                    failure(error?.localizedDescription ?? NSLocalizedString("Error, Try Again", comment: ""))
                }
                else{
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        do {
                            if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                                success(JSONData)
                            }
                        }
                    } else if httpResponse.statusCode == 400 {
                        do {
                            if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                                if let message = JSONData["message"] as? String
                                {
                                    
                                    failure(NSLocalizedString(message, comment: ""))
                                    
                                }
                            }
                        }
                    }else {
                        failure(NSLocalizedString("Error: \(httpResponse.statusCode)", comment: ""))
                    }
                }
                }.resume()
        }
        
        //MARK: - PUT Request
        //Multipart
        func put(url: URL, parameters: [String:Any],token: String,userPic : NSData?,apiImageKey: String,success:@escaping ([String: Any]) -> (),failure:@escaping (String) -> ()) {
            
            print("\n\nPUT with image::: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let boundary = generateBoundaryString()
            
            if !(token.isEmpty) {
                request.addValue(token, forHTTPHeaderField: "access_token")
            }
            request.addValue(basicAuthString, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBody(parameters: parameters, filePathKey: apiImageKey, imageDataKey: userPic, boundary: boundary) as Data
            
            let session = URLSession.shared
            
            session.dataTask(with: request) {(data,response,error) in
                
                if (error != nil){
                    print("Error  = " + (error?.localizedDescription)!)
                    failure((error?.localizedDescription) ?? NSLocalizedString("Error, Try Again", comment: ""))
                }
                else{
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            DispatchQueue.main.async {
                                print(jsonData as! [String: Any])
                                success(jsonData as! [String : Any])
                            }
                        }
                        catch {}
                    } else if httpResponse.statusCode == 400 {
                        do {
                            if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                                if let message = JSONData["message"] as? String
                                {
                                    
                                    failure(NSLocalizedString(message, comment: ""))
                                    
                                }
                            }
                        }
                    }else {
                        failure(NSLocalizedString("Error: \(httpResponse.statusCode)", comment: ""))
                    }
                }
                }.resume()
        }
        //Put raw data
        func put(url: URL, parameters: [String:Any],token: String,success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ()) {
            print("\n\nPUT::: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            if !(token.isEmpty) {
                request.addValue(token, forHTTPHeaderField: "access_token")
            }
            request.addValue(basicAuthString, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession.shared
            
            session.dataTask(with: request) {(data,response,error) in
                
                //            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //            print(responseString!)
                //
                if (error != nil){
                    failure(error?.localizedDescription ?? NSLocalizedString("Error, Try Again", comment: ""))
                }
                else{
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            DispatchQueue.main.async {
                                print(jsonData as! [String: Any])
                                success(jsonData as! [String: Any])
                            }
                        }
                        catch {}
                    }else if httpResponse.statusCode == 400 {
                        do {
                            if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                                if let message = JSONData["message"] as? String
                                {
                                    
                                    failure(NSLocalizedString(message, comment: ""))
                                    
                                }
                            }
                        }
                    }else{
                        failure(NSLocalizedString("Error: \(httpResponse.statusCode)", comment: ""))
                    }
                }
                }.resume()
        }
        //MARK: - POST Request
        // Raw data
        func post(url: URL, parameters: [String:Any],token: String,success:@escaping ([String : Any]) -> (),failure:@escaping (String) -> ()){
            print("\n\nPOST::: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if !token.isEmpty {
                request.addValue(token, forHTTPHeaderField: "access_token")
            }
            request.addValue(basicAuthString, forHTTPHeaderField: "Authorization")
            
            //        let config = URLSessionConfiguration.default
            //        config.httpAdditionalHeaders = ["Authorization" : basicAuthString,"Content-Type" : "application/json"]
            
            let session = URLSession.shared
            session.dataTask(with: request){(data,response,error) in
                if (error != nil){
                    print("Error  = " + error.debugDescription)
                    failure(error?.localizedDescription ?? NSLocalizedString("Error, Try Again", comment: ""))
                }
                else{
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            DispatchQueue.main.async {
                                print(jsonData as! [String: Any])
                                success(jsonData as! [String : Any])
                            }
                        }
                        catch {}
                    } else if httpResponse.statusCode == 400 {
                        do {
                            if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                                if let message = JSONData["message"] as? String
                                {
                                    
                                    failure(NSLocalizedString(message, comment: ""))
                                    
                                }
                            }
                        }
                    }else {
                        failure(NSLocalizedString("Error: \(httpResponse.statusCode)", comment: ""))
                    }
                }
                }.resume()
        }
        
        
        //FORM Data
        func post(url:URL,parameters:[String:Any],token: String,userPic : NSData?,imagekey: String,success:@escaping ([String: Any]) -> (),failure:@escaping (String) -> ()) {
            
            print("\n\nPOST with image::: \(url)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            if !token.isEmpty {
                request.addValue(token, forHTTPHeaderField: "access_token")
            }
            request.addValue(basicAuthString, forHTTPHeaderField: "Authorization")
            
            let boundary = generateBoundaryString()
            
            let session = URLSession.shared
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBody(parameters: parameters, filePathKey: imagekey, imageDataKey: userPic, boundary: boundary) as Data
            
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    
                    DispatchQueue.main.async {
                        failure(error?.localizedDescription ?? NSLocalizedString("Error, Try Again", comment: ""))
                    }
                    return
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString!)
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    do{
                        if let  JSONData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            DispatchQueue.main.async {
                                success(JSONData)
                                print(JSONData)
                            }
                        }
                    }
                } else if httpResponse.statusCode == 400 {
                    do {
                        if let JSONData = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]{
                            if let message = JSONData["message"] as? String
                            {
                                
                                failure(NSLocalizedString(message, comment: ""))
                                
                            }
                        }
                    }
                }else {
                    failure(NSLocalizedString("Error: \(httpResponse.statusCode)", comment: ""))
                }
                }.resume()
        }
        
        
        func createBody(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData?, boundary: String) -> NSData {
            
            let body = NSMutableData();
            if parameters != nil {
                for (key , value) in parameters!{
                    
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
            }
            if imageDataKey != nil {
                let filename = "image.jpg"
                let mimetype = "image/jpg"
                
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
                body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
                body.append(imageDataKey! as Data)
                body.append(Data("\r\n".utf8))
            }
            body.append(Data("--\(boundary)--\r\n".utf8))
            
            return body
        }
        
        func generateBoundaryString() -> String{
            return "Boundary-\(NSUUID().uuidString)"
        }
    }

