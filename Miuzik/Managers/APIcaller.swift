//
//  APIcaller.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 29/08/22.
//

import Foundation

final class APIcaller{
    static let shared = APIcaller()
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedtogetDATA
    }
    
    
//Albums
    public func getAlbumDetails(for album: Album, completion: @escaping(Result<Albumdetailsres, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Albumdetailsres.self, from: data)
                    completion(.success(result))
                }catch{
                    
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
//Playlists
  
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping(Result<Playlistdetailsres, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Playlistdetailsres.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    
    
    
    
//Profile
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET
        ){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let  data = data, error == nil else {
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                
                do
                {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    completion(.success(result))
                } catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
// browse
    public func getNewReleases(completion: @escaping((Result<NewReleasesResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=48"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylist(completion: @escaping((Result<FeaturedPlaylistResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"),
            type: .GET
        ) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // Call Get Recommendation API
    public func getRecommendations(genres: Set<String>,completion: @escaping((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
            type: .GET)
        {
            request in

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
            
        }
    }
    
    public func getRecommendedGenres(completion: @escaping((Result<RecommendedGenres, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET
        ){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedtogetDATA))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenres.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
            
        }
        
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
        
    }
    
    
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        loginManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
    }
}
