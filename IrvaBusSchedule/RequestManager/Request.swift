//
//  Request.swift
//  IrvaBusSchedule
//
//  Created by Cat on 4/5/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit
import Alamofire

class Request {
    
    struct SerializationKeys {
        static let destination = "destination"
        static let hours       = "hours"
        static let minutes     = "minutes"
        static let tripType    = "tripType"
    }
    
    class func sendRequest(completion: @escaping () -> Void) {
        Alamofire.request("https://irvabusschedule.firebaseio.com/schedule.json", method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let jsonArray = try!JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                    Storage.shared.scheduleDataFirstScreen = []
                    Storage.shared.scheduleDataSecondScreen = []

                    for responseDictionary in jsonArray {
                        let newTaskForFirstScreen = Model()
                        let newTaskForSecondScreen = Model()
                        var isToOffice = false
                        
                        if let destination = responseDictionary[SerializationKeys.destination] as? String {
                            if destination == "toOffice" {
                                newTaskForFirstScreen.destination = destination
                                isToOffice = true
                            } else {
                                newTaskForSecondScreen.destination = destination
                            }
                        }
                        
                        if let hour = responseDictionary[SerializationKeys.hours] as? Int {
                            if isToOffice == true {
                                newTaskForFirstScreen.hours = hour
                            } else {
                                newTaskForSecondScreen.hours = hour
                            }
                        }
                        
                        if let minute = responseDictionary[SerializationKeys.minutes] as? Int {
                            if isToOffice == true {
                                newTaskForFirstScreen.minutes = minute
                            } else {
                                newTaskForSecondScreen.minutes = minute
                            }
                        }
                        
                        if let toPlace = responseDictionary[SerializationKeys.tripType] as? String {
                            if isToOffice == true {
                                newTaskForFirstScreen.tripType = toPlace
                            } else {
                                newTaskForSecondScreen.tripType = toPlace
                            }
                        }
                        
                        if isToOffice == true {
                            Storage.shared.scheduleDataFirstScreen.append(newTaskForFirstScreen)
                        } else {
                            Storage.shared.scheduleDataSecondScreen.append(newTaskForSecondScreen)
                        }
                    }
                    
                    DateHelperFirstScreen.intervalToDeparture()
                    DateHelperSecondScreen.intervalToDeparture()

                    DateHelperFirstScreen.nearestTrip()
                    DateHelperSecondScreen.nearestTrip()
                    
                    completion()
                    debugPrint("HTTP Response Body: \(String(describing: response.data))")
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                }
        }
    }
    
}
