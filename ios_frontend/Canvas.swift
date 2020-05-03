//
//  File.swift
//  ios_frontend
//
//  Created by Андрей Кабылин on 02.05.2020.
//  Copyright © 2020 RedGoosePaws. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

class SKCanvasViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = RenderScene()
        scene.scaleMode = .resizeFill
        
        let skView = self.view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
    
    override func loadView() {
        self.view = SKView()
    }
}

struct SKCanvasView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SKCanvasViewController
    
    func makeUIViewController(context: Context) -> SKCanvasViewController {
        return SKCanvasViewController()
    }
    
    func updateUIViewController(_ uiViewController: SKCanvasViewController, context: Context) {
        // Nothing
    }
 }
