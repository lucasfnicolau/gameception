import Foundation
import SpriteKit
import PlaygroundSupport

public class Tutorial: SKScene {
    var playBtn: SKSpriteNode!
    
    public override func sceneDidLoad() {
        playBtn = childNode(withName: "//playBtn") as? SKSpriteNode
        playBtn?.name = "playBtn"
    }
    
    public override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        for node in touchedNodes.reversed() {
            if node.name == "playBtn" {
                playBtn.alpha = 0.5
                playBtn?.texture = SKTexture(imageNamed: "PlayBtnPressed")
            }
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        playBtn.alpha = 1
        playBtn?.texture = SKTexture(imageNamed: "PlayBtn")
        
        let location = event.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        for node in touchedNodes.reversed() {
            if node.name == "playBtn" {
                if let scene0 = Scene0(fileNamed: "_Scene0") {
                    let transition = SKTransition.flipVertical(withDuration: 1.0)
                    scene0.scaleMode = .aspectFill
                    scene?.view?.presentScene(scene0, transition: transition)
                }
            }
        }
    }
}
