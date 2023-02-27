//
//  GenerationViewModel.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 27/02/23.
//

import Foundation
import UIKit

class GenerationViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var generatedImages: [String] = []
    @Published var isLoading = false
    @Published var isDownloaded = false
    @Published var screenWidth = UIScreen.main.bounds.width
    @Published var screenHeight = UIScreen.main.bounds.height
}
