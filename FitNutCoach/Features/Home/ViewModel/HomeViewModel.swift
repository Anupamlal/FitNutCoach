//
//  HomeViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published var profileModel = ProfileModel()
    @Published var numberOfWorkoutDays = 3
    
    private let profileManager: ProfileManager
    private var cancellable = Set<AnyCancellable>()
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func onAppear() {
        Task {
            await self.profileManager.loadData()
        }
        
        self.profileManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink { profileModel in
                self.profileModel = profileModel
            }
            .store(in: &cancellable)
    }
}
