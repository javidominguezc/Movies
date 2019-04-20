//
//  VideoParser.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

class VideoParser {
    
    func parser(_ responseObject: Any?) -> [VideoBaseModel]? {
        
        guard let response = responseObject as? [String: Any], let results = response["results"] as? [[String: Any]] else {
            
            return nil
        }
        
        var videosInfo = [VideoBaseModel]()
        
        for result in results {
            
            let id = (result["id"] as? Int) ?? 0
            let key = result["key"] as? String
            let name = result["name"] as? String
            let site = result["site"] as? String
            let type = result["type"] as? String
            
            let videoInfo = VideoBaseModel(id: id, key: key, name: name, site: site, type: type)
            videosInfo.append(videoInfo)
        }
        
        return videosInfo
    }
}
