//
//  RenderScene.swift
//  ios_frontend
//
//  Created by Андрей Кабылин on 02.05.2020.
//  Copyright © 2020 RedGoosePaws. All rights reserved.
//

import Foundation
import SpriteKit

class RenderScene: SKScene {
    private var color: [SKColor] = []
    private var pos2f: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        color.reserveCapacity(1000)
        pos2f.reserveCapacity(1000)
        
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        self.camera = cameraNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        step()
        clearAll()
        set_view_port_size(Int32(size.width), Int32(size.height))
        
        clearData()
        let execCommands = getExecCommands()
        
        for command in execCommands {
            handleExecCommand(command)
        }

        clearData()
        let renderCommands = getRenderCommands()
        
        for command in renderCommands {
            handleRenderCommand(command)
        }
    }
    
    private func updateCameraPosition() {
        assert(pos2f.count > 0)

        camera?.position = CGPoint(
            x: size.width / 2 - pos2f[0].x,
            y: size.height / 2 - pos2f[0].y
        )

        clearData()
    }

    private func handleRenderCommand(_ command: RenderCommand) {
        switch command {
        case .drawLines:
            drawLines()
        case .pushColor(let r, let g, let b, let a):
            color.append(
                SKColor(
                    red: CGFloat(r),
                    green: CGFloat(g),
                    blue: CGFloat(b),
                    alpha: CGFloat(a)
                )
            )
        case .pushPos2f(let x, let y):
            pos2f.append(
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(y)
                )
            )
        case .setColorUniform:
            break;
        case .pushColorShader:
            break;
        }
    }
    
    private func handleExecCommand(_ command: ExecCommand) {
        switch command {
        case .pushPos2f(let x, let y):
            pos2f.append(
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(y)
                )
            )
        case .updateCameraPosition:
            updateCameraPosition()
        }
    }

    private func drawLines() {
        let lines = SKShapeNode()
        let pathToDraw = CGMutablePath()
        
        var isMove = true
        
        for pos in pos2f {
            if (isMove) {
                pathToDraw.move(to: pos)
            } else {
                pathToDraw.addLine(to: pos)
            }
            
            isMove = !isMove
        }
        
        lines.path = pathToDraw
        lines.strokeColor = color.last!
        lines.lineWidth = 1
        lines.name = "lines"
        
        addChild(lines)
        clearData()
    }
    
    private func clearAll() {
        enumerateChildNodes(withName: "lines", using: { node, stop in
          node.removeFromParent()
        })

        clearData()
    }
    
    private func clearData() {
        color.removeAll()
        pos2f.removeAll()
    }
}
