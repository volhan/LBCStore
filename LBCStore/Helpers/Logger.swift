//
//  Logger.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation

final class Logger {
    static func logError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .long)
        let fileName = (file as NSString).lastPathComponent
        print("🚨 Error at \(timestamp) in \(fileName) -> \(function) [Line \(line)]: \(message)")
    }
}
