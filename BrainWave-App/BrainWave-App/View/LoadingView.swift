//
//  LoadingView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 08/03/23.
//

import SwiftUI
import SpriteKit

class LoadingScene: SKScene {
    var loader: SKSpriteNode = SKSpriteNode(imageNamed: "Loading1.png")
    override func didMove(to view: SKView) {
        loader.size = CGSize(width: 0.3, height: 0.3)
        loader.position = CGPoint(x: 0.5, y: 0.46)
        var TextureArray = [SKTexture]()
        for i in 0...120 {
            var imageFileName = String(format: "Loading-\(i).png", i)
            TextureArray.append(SKTexture(imageNamed: imageFileName))
        }
        var loading = SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.01))
        loader.run(loading)
        addChild(loader)
    }
}

struct LoadingView: UIViewRepresentable {
    func updateUIView(_ uiView: SKView, context: Context) {
    }

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.presentScene(LoadingScene())
        return view
    }
}
