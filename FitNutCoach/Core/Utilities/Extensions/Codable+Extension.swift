//
//  Codable+Extension.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 12/10/24.
//

import SwiftUI

extension Encodable {
    
    func asDictionary() -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting model to dictionary: \(error)")
            return nil
        }
    }
}
