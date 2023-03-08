//
//  LoadingView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 08/03/23.
//

import SwiftUI
import SpriteKit

class LoadingScene: SKScene {
//    var loader: SKSpriteNode = SKSpriteNode(imageNamed: "Loading1.png")
    override func didMove(to view: SKView) {
//        var TextureArray = [SKTexture]()
//        for i in 1...40{
//
//            var imageFileName = String(format: "Loading.gif")
//            TextureArray.append(SKTexture(imageNamed: imageFileName))
//
//        }
//        var loading = SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.3))
//        loader.run(loading)
        let texture = SKTexture(imageNamed: "Loading.gif")
        let sprite = SKSpriteNode(texture: texture)
        addChild(sprite)
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
