//
//  DispatchQueue+Extension.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/10/24.
//

import SwiftUI

extension DispatchQueue {
    
    func runInMainThread(_ completion:@escaping ()->Void){
        if Thread.isMainThread {
            completion()
        }else{
            DispatchQueue.main.async {
                self.runInMainThread(completion)
            }
        }
    }
}
