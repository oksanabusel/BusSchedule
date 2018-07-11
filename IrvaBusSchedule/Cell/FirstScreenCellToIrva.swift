//
//  FirstScreenCellToIrva.swift
//  IrvaBusSchedule
//
//  Created by Cat on 4/5/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit

class FirstScreenCellToIrva: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfBusRide: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    
    func setData(data: Model) {
        timeLabel.text = formatDate(hours: data.hours, mins: data.minutes)
        typeOfBusRide.text = data.tripType
        timeLeftLabel.text = String(data.intervalToDepartureOnTheScreen)
        catImage.isHidden = !data.isNearestTrip
    }
    
    func formatDate(hours: Int, mins: Int) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hours
        components.minute = mins
        
        let rowDate = calendar.date(from: components)
        let result = formatter.string(from: rowDate!)
        
        return result
    }
    
}
