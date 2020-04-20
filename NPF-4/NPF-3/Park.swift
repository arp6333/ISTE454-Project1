//
//  Park.swift
//  NPF-4
//
//  Created by Ellie on 1/30/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Park: NSObject, MKAnnotation
{
    override var description: String
    {
        "{\n\tparkName: \(parkName)\n\tparkLocation: \(parkLocation)\n\tdateFormed: \(dateFormed)\n\tarea: \(area)\n\tlink: \(link)\n\tlocation: \(location)\n\timageLink: \(imageLink)\n\tparkDescription: \(parkDescription)\n\tcoordinate: \(coordinate)\n}"
    }
    
    private var location: CLLocation?
    private var imageLink: String = ""
    private var parkDescription: String = ""
    
    private var parkName : String = ""
    private var parkLocation : String = ""
    private var dateFormed : String = ""
    private var area : String = ""
    private var link : String = ""
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return location!.coordinate
        }
    }
     
    var title : String? {
         get {
             return parkName
         }
     }
     
    var subtitle : String? {
         get {
             return "\(parkLocation), \(area)"
         }
    }
    
    convenience override init ()
    {
        self.init(parkName: "Unknown", parkLocation: "Unknown", dateFormed: "Unknown", area: "Unknown", link: "Unknown", location: nil, imageLink: "Unknown", parkDescription: "Unknown")
    }
    
    init(parkName: String, parkLocation: String, dateFormed: String, area: String, link: String, location: CLLocation?, imageLink: String, parkDescription: String)
    {
        super.init()
        set(parkName: parkName)
        set(parkLocation: parkLocation)
        set(date: dateFormed)
        set(area: area)
        set(link: link)
        
        set(location: location)
        set(imageLink: imageLink)
        set(parkDescription: parkDescription)
    }

    func getParkName() -> String
    {
        parkName
    }

    func set(parkName: String)
    {
        let name = parkName.trimmingCharacters(in: .whitespacesAndNewlines)
        if 3 ... 75 ~= name.count
        {
            self.parkName = name
        }
        else
        {
            print("Bad value of \(name) in set(parkName): setting to TBD")
            self.parkName = "TBD"
            
        }
    }
    
    func getParkLocation() -> String
    {
        parkLocation
    }

    func set(parkLocation: String)
    {
        let location = parkLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        if 3 ... 75 ~= location.count
        {
            self.parkLocation = location
        }
        else
        {
            print("Bad value of \(location) in set(parkLocation): setting to TBD")
            self.parkLocation = "TBD"
            
        }
    }
    
    func getDateFormed() -> String
    {
        dateFormed
    }

    func set(date: String)
    {
        dateFormed = date
    }
    
    func getArea() -> String
    {
        area
    }

    func set(area: String)
    {
        self.area = area
    }
    
    func getLink() -> String
    {
        link
    }

    func set(link: String)
    {
        self.link = link
    }
    
    func getLocation() -> CLLocation?
    {
        location
    }

    func set(location: CLLocation?)
    {
        self.location = location
    }
    
    func getImageLink() -> String
    {
        imageLink
    }

    func set(imageLink: String)
    {
        self.imageLink = imageLink
    }
    
    func getParkDescription() -> String
    {
        parkDescription
    }

    func set(parkDescription: String)
    {
        self.parkDescription = parkDescription
    }

}
