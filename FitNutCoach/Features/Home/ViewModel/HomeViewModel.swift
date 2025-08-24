//
//  HomeViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var loggedInUserName = "Anupam"
    @Published var numberOfWorkoutDays = 3
}
