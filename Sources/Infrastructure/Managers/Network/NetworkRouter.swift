//
//  NetworkRouter.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import Alamofire

enum Router {
    
    case getPopularMovies
    case getMovieDetails(path: String)
    case getMovieVideos(path: String)
    case getMovieImage(path: String)
}

protocol ContextProvider {
    
    var context: String { get }
    func asURLRequestAndParams() throws -> (URLRequest, Parameters?)
}

// MARK: URLRequestConvertible
extension Router: URLRequestConvertible {
    
    private static let baseURLString = AppConfig.APIUrl.urlString
    private static let baseImageURLString = AppConfig.APIUrl.urlImageString
    
    private static let KApiKey = "api_key"
    private static let apiKey = AppConfig.APIKeys.apiKey
    
    private struct Endpoint {
        
        static let popular = "/movie/popular"
        static let details = "/movie"
        static let videos = "/movie"
        static let image = ""
    }
    
    private struct EndpointKeys {
        
        static let videos = "videos"
    }
    
    private func baseUrl() -> String {
        
        switch self {
            
        case .getPopularMovies:
            return Router.baseURLString
        case .getMovieDetails:
            return Router.baseURLString
        case .getMovieVideos:
            return Router.baseURLString
        case .getMovieImage:
            return Router.baseImageURLString
        }
    }
    
    private func asHttpMethod() -> HTTPMethod {
        
        switch self {
            
        case .getPopularMovies:
            return .get
        case .getMovieDetails:
            return .get
        case .getMovieVideos:
            return .get
        case .getMovieImage:
            return .get
        }
    }
    
    private var encoding: ParameterEncoding {
        
        switch self {
            
        case .getPopularMovies:
            
            return URLEncoding.default
        case .getMovieDetails:
            
            return URLEncoding.default
        case .getMovieVideos:
            
            return URLEncoding.default
        default:
            
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let (urlRequest, parameters) = try asURLRequestAndParams()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}

extension Router: ContextProvider {
    
    var context: String {
        
        switch self {
            
        case .getPopularMovies:
            return "getPopularVideos"
        case .getMovieDetails:
            return "getMovieDetails"
        case .getMovieVideos:
            return "getMovieVideos"
        case .getMovieImage:
            return "getMovieImage"
        }
    }
    
    func asURLRequestAndParams() throws -> (URLRequest, Parameters?) {
        
        var result: (path: String, parameters: Parameters?) = {
            
            switch self {
                
            case .getPopularMovies:
                
                return (Endpoint.popular, nil)
            case .getMovieDetails(let endpointPath):
                
                let endpoint = "\(Endpoint.details)/\(endpointPath)"
                return (endpoint, nil)
            case .getMovieVideos(let endpointPath):
                
                let endpoint = "\(Endpoint.videos)/\(endpointPath)/\(Router.EndpointKeys.videos)"
                return (endpoint, nil)
            case .getMovieImage(let endpointPath):
                
                let endpoint = "\(Endpoint.image)/\(endpointPath)"
                return (endpoint, nil)
            }
        }()
        
        let stringUrl = baseUrl()
        let url = try stringUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = asHttpMethod().rawValue
        if stringUrl == Router.baseURLString {

            result.parameters = [Router.KApiKey: Router.apiKey]
        }
        
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return (urlRequest, result.parameters)
    }
}
