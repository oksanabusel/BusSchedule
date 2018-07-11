//
//  Storage.swift
//  IrvaBusSchedule
//
//  Created by Cat on 4/5/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit

class Storage {
    
    static var shared = Storage()
    
    var scheduleDataFirstScreen: [Model] = []
    var scheduleDataSecondScreen: [Model] = []
    
    private init() {}

}
