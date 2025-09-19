//
//  Router.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import SwiftUI

class Router<T: Hashable>: ObservableObject {

    @Published var navigationPath = NavigationPath()
    
    func navigate(to destination: T) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast(navigationPath.count)
    }
    
    func navigateBackTo(kTh: Int) {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast(kTh)
    }
}
