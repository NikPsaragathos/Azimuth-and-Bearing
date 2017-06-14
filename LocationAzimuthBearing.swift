//
//  LocationBearing.swift
//  globallocator
//
//  Created by Nik Psaragkathos on 27/05/2017.
//  Copyright © 2017 NIK PSARAGKATHOS. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationAzimuthBearing{
    
    //Convert Degrees to Radian
    private func DegreesToRadians(_ degrees : Double) -> Double {
        return (degrees * Double.pi / 180)
    }
    
    //Convert Radian to Degrees
    private func RadiansToDegrees(_ radians : Double) -> Double {
        return radians * 180 / Double.pi
    }
    
    //Taking the two location points and give the azimuth with a little help of mathimatics
    func azimuthToLocation(currentLocation: CLLocation , latitude : Double, longitude : Double ) -> Int {
        let lat1 = DegreesToRadians(currentLocation.coordinate.latitude)
        let lng1 = DegreesToRadians(currentLocation.coordinate.longitude)
        let lat2 = DegreesToRadians(latitude)
        let lng2 = DegreesToRadians(longitude)
        let deltalng = lng2 - lng1
        
        let y = sin(deltalng) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltalng)
        
        let azimuth = atan2(y, x) + 2 * Double.pi
        
        var azimuthDegrees = RadiansToDegrees(azimuth);
        
        azimuthDegrees = Double(Int(azimuthDegrees) % 360)
        
        print("Bearing Degrees : \(azimuthDegrees)")
        
        return Int(azimuthDegrees);
    }
    
    //The function that turn our compass to azimuth direction
    func compassRotation (bearing : Int, compassDegrees : CLHeading)-> Double{
        
        let rotationInDegree = fmod(Double(bearing) - compassDegrees.trueHeading , 360)
        
        print("Rotation in degrees : \(rotationInDegree)")
        
        
        return rotationInDegree
    }
    
    //Calculate the distance Betwwen the two points
    func distanceBetween(currentLocation: CLLocation , latitude : Double, longitude : Double ) -> Double {
        
        //My location
        let myLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        //My target location
        let myTargetLocation = CLLocation(latitude: latitude , longitude: longitude)
        
        //Measuring my distance to my buddy's (in km) if  /1000
        let distance = myLocation.distance(from: myTargetLocation)
        
        //Display the result in m
        print(String(format: "The distance to my buddy is %.01fm", distance))
        
        return distance
        
    }
    
    //Converting Azimuth to Bearing
    //Declaring the four  cartesian quadrants
    private enum BearingQuadrants {
        case NorthEastQuadrant
        case SouthEastQuadrant
        case SouthWestQuadrant
        case NorthWestQuadrant
        case none
    }
    
    //A help func for finding Bearing
    private func findBearing(azimuth : Int) -> BearingQuadrants {
        
        switch azimuth {
        case 0..<90 :
            return .NorthEastQuadrant
        case 90..<180 :
            return .SouthEastQuadrant
        case 180..<270 :
            return .SouthWestQuadrant
        case 270...360 :
            return .NorthWestQuadrant
        default:
            print("Not acceptable degrees")
            return .none
        }
        
    }
    
    //Converting Azimuth to Bearing
    func takeAzimuthReturnBearing(_ azimuth : Int) -> String {
        
        let quadrant : BearingQuadrants = findBearing(azimuth: azimuth)
        
        var bearing : String?
        
        switch quadrant {
        case .NorthEastQuadrant:
            bearing = "N"+String(describing: azimuth)+"E"
        case .SouthEastQuadrant:
            bearing = "S"+String(describing: 180 - azimuth)+"E"
        case .SouthWestQuadrant:
            bearing = "S"+String(describing: azimuth - 180)+"W"
        case .NorthWestQuadrant:
            bearing = "N"+String(describing: 360 - azimuth)+"W"
        case .none:
            print("error")
        }
        
        print("Bearing : \(bearing!)")
        
        return bearing!
    }

    
}

