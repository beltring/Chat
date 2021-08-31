//
//  DateFormatterExtensions.swift
//  Chat
//
//  Created by User on 8/27/21.
//

import Foundation

extension DateFormatter {
    func convert(timeInterval: Int32?) -> String {
        guard let timeInterval = timeInterval else { return ""}
        let interval = TimeInterval(timeInterval)
        let date = Date(timeIntervalSince1970: interval)
        
        self.dateFormat = date.isToday ? "HH:mm" : "HH:mm dd.MM"
        
        return self.string(from: date)
    }
}
