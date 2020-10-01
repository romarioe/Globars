//
//  NetworkManager.swift
//  Globars
//
//  Created by Roman Efimov on 30.09.2020.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
    func auth(username: String, password: String, completion: @escaping (String?, Bool?) -> Void){

        let UrlString = "https://test.globars.ru/api/auth/login"
        let url = URL(string: UrlString)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("ru", forHTTPHeaderField: "Accept-Language")
            
            let authData = AuthModel(username: username, password: password)
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(authData)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
                
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                let jsonDecoder = JSONDecoder()
                let responseModel = try? jsonDecoder.decode(AuthResponseModel.self, from: data)
                completion(responseModel?.data, responseModel?.success)
                
            }
            task.resume()
        }
    
    
    
    
    
    func sessions(token: String, completion: @escaping (String?) -> Void){
        
        let UrlString = "https://go.globars.ru/api/tracking/sessions"
        
        guard let url = URL(string: UrlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("ru", forHTTPHeaderField: "Accept-Language")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let responseData = try? jsonDecoder.decode(SessionModel.self, from: data)
            
            guard let model = responseData else {
                completion (nil)
                return
            }
            
            var sessionId: String = ""
            
            for item in model.data {
                switch item {
                case .id(let id):
                    sessionId = id.id
                }
            }
            
            completion (sessionId)
        }
        task.resume()
    }
    
    
    
    
    func units(token: String, sessionId: String, completion: @escaping (UnitsModel?) -> Void){
        let UrlString = "https://go.globars.ru/api/tracking/" + sessionId + "/units?mobile=true"
        guard let url = URL(string: UrlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("ru", forHTTPHeaderField: "Accept-Language")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let responseData = try? jsonDecoder.decode(UnitsModel.self, from: data)
            
            guard let model = responseData else {
                completion (nil)
                return
            }
            
            completion (model)
        }
        task.resume()

    }

}
    

