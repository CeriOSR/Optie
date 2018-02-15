//
//  Geocoder.swift
//  Optie
//
//  Created by Rey Cerio on 2018-02-04.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import PromiseKit
import Alamofire

enum Errors: Error {
    case unKnowError
    case geocodingManagerDictionary
    case noMatchingLocation
}

class Geocoding {
    
    var coordinates: CLLocationCoordinate2D
    var name: String?
    var formattedAddress: String?
    var boundNorthEast: CLLocationCoordinate2D?
    var boundSouthWest: CLLocationCoordinate2D?
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
    
}

class GeocodingResult {
    var native: Geocoding?
    var googleMaps: Geocoding?
    var address: String
    
    init(_ address: String) {
        self.address = address
    }
    
    func getDistance() -> Int? {
        if native != nil || googleMaps != nil {
            let coordinate1 = CLLocation(latitude: native!.coordinates.latitude, longitude: native!.coordinates.longitude)
            let coordinate2 = CLLocation(latitude: googleMaps!.coordinates.latitude, longitude: googleMaps!.coordinates.longitude)
            return Int(coordinate1.distance(from: coordinate2))
        } else {
            return nil
        }
    }
    
}

class NativeGeocoding {
    var address : String
    lazy var geocoder = CLGeocoder()
    init(_ address: String) {
        self.address = address
    }
    
    func geocode() -> Promise<Geocoding> {
        return Promise { fulfill, reject in
            firstly{
                self.geocodeAddressString()
                }.then { (placemarks) -> Promise<Geocoding> in
                    self.processResponse(withPlacemarks: placemarks)
                }.then { (geocoding) -> Void in
                    fulfill(geocoding)
                }.catch { (error) in
                    reject(error)
            }
        }
    }
    
    // MARK: - Get an array of CLPlacemark
    private func geocodeAddressString() -> Promise<[CLPlacemark]> {
        return Promise { fulfill, reject in
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if (error != nil) {
                    reject(error!)
                } else {
                    fulfill(placemarks!)
                }
            }
        }
    }
    
    // MARK: - Convert an array of CLPlacemark to a Geocoding Object
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?) -> Promise<Geocoding> {
        return Promise { fulfill, reject in
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let geocoding = Geocoding(coordinates: location.coordinate)
                fulfill(geocoding)
            } else {
                reject( Errors.noMatchingLocation)
            }
        }
    }
    
}

//google geocoder

//let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
//let apikey = "AIzaSyAbp6sryjHWNB1o5SIW6ANJFC0EVHV4EiQ"
////    func getLatLngForZip(zipCode: String) {
////        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
////        let data = try! Data(contentsOf: url! as URL)
//////        let data = NSData(contentsOfURL: url! as URL)
////        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
////        if let result = json["results"] as? NSArray {
////            if let geometry = result[0]["geometry"] as? NSDictionary {
////                if let location = geometry["location"] as? NSDictionary {
////                    let latitude = location["lat"] as! Float
////                    let longitude = location["lng"] as! Float
////                    print("\n\(latitude), \(longitude)")
////                }
////            }
////        }
////    }
//func getLatLongForZip(zipCode: String) {
//    let url = URL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
//    let data = try! Data(contentsOf: url! as URL)
//    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
//    if let result = json["results"] as? [[String: Any]] {
//        if let geometry = result[0]["geometry"] as? [String: Any] {
//            if let location = geometry["location"] as? [String: Any] {
//                let latitude = location["lat"] as! Float
//                let longitude = location["lng"] as! Float
//                print("\n \(latitude), \(longitude)")
//            }
//        }
//    }
//}



