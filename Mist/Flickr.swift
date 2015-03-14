//
//  Flickr.swift
//  Mist
//
//  Created by Jack Cook on 3/14/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Flickr {
    
    class func getPhoto(location: String, lat: Float, lon: Float, completion: (photos: [Photo]) -> Void) {
        let url = "https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=\(Keys.flickrKey())&format=json&nojsoncallback=1&content_type=1&media=photos&tags=\(location),landscape&lat=\(lat)&lon=\(lon)&safe_search=1&sort=relevance"
        
        request(.GET, url).responseJSON { (_, _, json, error) -> Void in
            let json = JSON(json!)
            if let photos = json["photos"]["photo"].array {
                var retrievedPhotos = [Photo]()
                for photo in photos {
                    if let id = photo["id"].string {
                        if let owner = photo["owner"].string {
                            if let secret = photo["secret"].string {
                                if let server = photo["server"].string {
                                    if let farm = photo["farm"].int {
                                        if let title = photo["title"].string {
                                            let retrievedPhoto = Photo(id: id, owner: owner, secret: secret, server: server, farm: farm, title: title)
                                            retrievedPhotos.append(retrievedPhoto)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                completion(photos: retrievedPhotos)
            }
        }
    }
}

class Photo: NSObject {
    
    var id: String!
    var owner: String!
    var secret: String!
    var server: String!
    var farm: Int!
    var title: String!
    
    init(id: String, owner: String, secret: String, server: String, farm: Int, title: String) {
        super.init()
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
    }
    
    func imageURL() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
