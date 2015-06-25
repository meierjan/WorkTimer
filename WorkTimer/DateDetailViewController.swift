//
//  DateDetailViewController.swift
//  WorkTimer
//
//  Created by Jan Meier on 25.06.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class DateDetailViewController : UIViewController {
    
    private var mEvent : EKEvent? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    // MARK: public API
    func setEventForDate(event: EKEvent) {
        self.mEvent = event;
    }
}