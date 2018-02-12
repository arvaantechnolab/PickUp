//
//  CLLocationExtension.swift

import CoreLocation

extension CLLocation {

    func distanceString(_ otherLocation : CLLocation?) -> String{
        if otherLocation == nil {
            return "Other location is nil"
        }
        let distance = self.distance(from: otherLocation!)
        if distance > 1000 {
            let km = distance / 1000
            return String(format: "%.2f Km", km);
        }
        else {
            return String(format: "%d Meter", Int(distance));
        }
    }
    

}
