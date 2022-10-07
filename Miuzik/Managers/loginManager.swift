//
//  loginManager.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 29/08/22.
//

import Foundation

final class loginManager    {
    static let shared = loginManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "e7faef97acbf44c293093c8512f73296"
        static let clientSecretID = "aaebee0c302140d5967780d9d4c70dbf"
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://open.spotify.com"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signINurl: URL? {
        
        let query = "?client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&response_type=code&show_dialog=TRUE"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)\(query)"
        
        return URL(string: string)
    }
    
    var isSignedin : Bool {
        return accesToken != nil
    }
    
    private var accesToken : String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken : String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var expiryToken : Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldrefreshToken : Bool {
        guard let expirationDate = expiryToken else{
            return false
        }
        let currentDate = Date()
        return currentDate.addingTimeInterval(300) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void) ){
            guard let url = URL(string: Constants.tokenApiUrl) else {
                return
            }
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let basicToken = Constants.clientID+":"+Constants.clientSecretID
            let data = basicToken.data(using: .utf8)
            guard let b64string = data?.base64EncodedString() else {
                print("Failure to get Base64")
                completion(false)
                return
                
            }
            request.setValue("Basic \(b64string)", forHTTPHeaderField: "Authorization")
            request.httpBody = components.query?.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) {[weak self] data,_, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do{
                    let result = try JSONDecoder().decode(Loginresponse.self, from: data)
                    self?.cacheToken(result: result)
                    completion(true)
                }
                catch{
                    print(error.localizedDescription)
                    completion(true)
                }
                
            }
            task.resume()
        }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    // supplies valid token to be used with api calls
    public func withValidToken(completion: @escaping(String) -> Void) {
        guard !refreshingToken else{
            // Append completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldrefreshToken {
            //Refresh
            refreshIfNecessary{ [weak self] success in
                    if let token = self?.accesToken, success{
                        completion(token)
                    }
            }
        } else if let token = accesToken{
            completion(token)
        }
    }
    
    public func refreshIfNecessary(completion: ((Bool) -> Void)?){
        guard !refreshingToken else{
            return
        }
        
        guard shouldrefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //Refresh the token
        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.clientSecretID
        let data = basicToken.data(using: .utf8)
        guard let b64string = data?.base64EncodedString() else {
            print("Failure to get Base64")
            completion?(false)
            return
            
        }
        request.setValue("Basic \(b64string)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data,_, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(Loginresponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch{
                print(error.localizedDescription)
                completion?(false)
            }
            
        }
        task.resume()
    }
    
    private func cacheToken(result: Loginresponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }



        
    }
    
    
