//
//  DateExtension.swift
//  Chat
//
//  Created by User on 8/31/21.
//

import Foundation
import UIKit

extension Date {
    static var today: Date { return Date() }
    
    var isToday: Bool {
        return Calendar.current.isDate(self, inSameDayAs: Date.today)
    }
}
