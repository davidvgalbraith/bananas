//
//  EventModel.swift
//  social-events
//
//  Created by David Galbraith on 8/2/15.
//  Copyright (c) 2015 David Galbraith. All rights reserved.
//

import UIKit

class EventModel: NSObject {
    let name: String
    let event_description: String
    
    init(name: String?, event_description: String?) {
        self.name = name ?? ""
        self.event_description = event_description ?? ""
    }
}
