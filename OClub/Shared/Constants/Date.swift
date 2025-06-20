//
//  Date.swift
//  O'Club
//
//  Created by 최효원 on 4/11/25.
//

import SwiftUI

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    var yearMonthFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        return formatter.string(from: self)
    }
    
    var yearFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년"
        return formatter.string(from: self)
    }
    
    var monthFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월"
        return formatter.string(from: self)
    }
    
    var timeFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    var timeSliceFormattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        return formatter.string(from: self)
    }
}
