//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

func performUIUpdate(_ completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}

class UdacityClient {
    
    enum HTTPMethod: String {
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentInformation(limit: Int)
        case addStudentLocation
        case updateStudentLocation(objectId: String)
        case getUserInfo(accountKey: String)
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .getStudentInformation(let limit): return Endpoints.base + "/StudentLocation" + "?count=\(limit)" + "&order=-updatedAt"
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation/" + objectId
            case.getUserInfo(let key): return Endpoints.base + "/users/" + key
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, excludeFirstFiveCharacters: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                performUIUpdate {
                    completion(nil, error)
                }
                return
            }
            let responseData = excludeFirstFiveCharacters ? trimFirstFiveCharacters(from: data) : data
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: responseData)
                performUIUpdate {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: responseData)
                    performUIUpdate {
                        completion(nil, errorResponse)
                    }
                } catch {
                    performUIUpdate {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func trimFirstFiveCharacters(from data: Data) -> Data {
        var responseData = data
        let range: Range = 5..<data.count
        responseData = data.subdata(in: range)
        return responseData
    }
    
    
    class func taskForRequest<RequestType: Encodable, ResponseType: Decodable>(method: HTTPMethod, url: URL, excludeFirstFiveCharacters: Bool, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body.self)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                performUIUpdate {
                    completion(nil, error)
                }
                return
            }
            let responseData = excludeFirstFiveCharacters ? trimFirstFiveCharacters(from: data) : data

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: responseData)
                print(responseObject)
                performUIUpdate {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: responseData)
                    performUIUpdate {
                        completion(nil, errorResponse)
                    }
                } catch {
                    performUIUpdate {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = UdacityLoginRequest(udacity: LoginRequest(email: email, password: password))
        taskForRequest(method: .post, url: Endpoints.login.url, excludeFirstFiveCharacters: true, body: body, responseType: LoginResponseModel.self) { (response, error) in
            if let response = response {
                UserManager.shared.accountModel = response.account
                UserManager.shared.sessionModel = response.session
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    
    class func add(studentInfo: AddStudentInformationRequest, completion: @escaping (AddLocationResponseModel?, Error?) -> Void) {
        taskForRequest(method: .post, url: Endpoints.addStudentLocation.url, excludeFirstFiveCharacters: false, body: studentInfo, responseType: AddLocationResponseModel.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func update(studentInfo: AddStudentInformationRequest, completion: @escaping (Bool, Error?) -> Void) {
        taskForRequest(method: .put, url: Endpoints.updateStudentLocation(objectId: UserManager.shared.objectId).url, excludeFirstFiveCharacters: false, body: studentInfo, responseType: UpdateLocationResponseModel.self) { (response, error) in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentInformation(completion: @escaping (StudentListResponse?, Error?) -> Void) {
        let url = Endpoints.getStudentInformation(limit: 100).url
        taskForGETRequest(url: url, excludeFirstFiveCharacters: false, responseType: StudentListResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUserInfo(completion: @escaping (UserModel?, Error?) -> Void) {
        let accountKey = UserManager.shared.accountModel?.key ?? ""
        let url = Endpoints.getUserInfo(accountKey: accountKey).url
        taskForGETRequest(url: url, excludeFirstFiveCharacters: true, responseType: UserModel.self, completion: { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    
    
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = HTTPMethod.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let _ = data else {
                performUIUpdate {
                    completion()
                }
                return
            }
            
            // Clean cache
            UserManager.shared.accountModel = nil
            UserManager.shared.sessionModel = nil
            UserManager.shared.userModel = nil
            UserManager.shared.objectId = ""
            
            performUIUpdate {                
                completion()
            }
        }
        task.resume()
    }
}
