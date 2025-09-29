//
//  AIFoodItemModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

struct AIFoodItemModel: Codable {
    var id = UUID().uuidString
    let name: String
    let crb: Double
    let ptn: Double
    let fat: Double
    let clry: Double
    let quantity: Double
    let mUnit: String?
    let cnfdnc: Double
    var foodSource: MealSourceType = .photo
    
    enum CodingKeys: String, CodingKey {
        case name
        case crb
        case ptn
        case fat
        case clry
        case quantity
        case mUnit
        case cnfdnc
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.mUnit = try container.decodeIfPresent(String.self, forKey: .mUnit)
        self.cnfdnc = try container.decode(Double.self, forKey: .cnfdnc)
        
        if let quantity = try? container.decode(Double.self, forKey: .quantity) {
            self.quantity = quantity
            
            let totalCarbs = try container.decode(Double.self, forKey: .crb)
            let totalProtein = try container.decode(Double.self, forKey: .ptn)
            let totalFat = try container.decode(Double.self, forKey: .fat)
            let totalCalorie = try container.decode(Double.self, forKey: .clry)
            
            if self.quantity > 100 {
                self.crb = (totalCarbs / self.quantity) * 100		
                self.ptn = (totalProtein / self.quantity) * 100
                self.fat = (totalFat / self.quantity) * 100
                self.clry = (totalCalorie / self.quantity) * 100
                
            }else {
                self.crb = totalCarbs
                self.ptn = totalProtein
                self.fat = totalFat
                self.clry = totalCalorie
            }
            
        }else {
            self.quantity = 0.0
            self.crb = 0
            self.ptn = 0
            self.fat = 0
            self.clry = 0
        }
    }
}
