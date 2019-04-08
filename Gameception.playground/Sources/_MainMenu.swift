import Foundation
import SpriteKit
import PlaygroundSupport

public class MainMenu: SKScene {
    var label: SKLabelNode!
    var inceptionGame: SKSpriteNode!
    var phone: SKSpriteNode!
    var phoneOff: SKSpriteNode!
    
    var isLoaded = false
    var tutorialTimer: Timer!
    
    let texts = [
    "Welcome to Gameception!",
    "You are about to play a game that plays a game...",
    "Mindblowing, right? 🤯",
    "You'll help the player through the \"Portals\" game",
    "Soooo, let's begin!",
    "To start, tap on the \"Portals\" game in the phone below:"
    ]
    var i = 0
    
    public override func sceneDidLoad() {
        label = childNode(withName: "//label") as? SKLabelNode
        label.text = texts[i]
        inceptionGame = childNode(withName: "//inceptionGame") as? SKSpriteNode
        inceptionGame.name = "inceptionGame"
        phone = childNode(withName: "//phone") as? SKSpriteNode
        phoneOff = childNode(withName: "//phoneOff") as? SKSpriteNode
        
        let fadeOut = SKAction.fadeOut(withDuration: 18)
        phoneOff.run(fadeOut)
        
        animate()
    }

    func animate() {
        tutorialTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeTexts), userInfo: nil, repeats: true)
    }
    
    @objc func changeTexts() {
        label.text = texts[i]
        if i < texts.count - 1 {
            i += 1
        } else {
            tutorialTimer.invalidate()
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        for node in touchedNodes.reversed() {
            if node.name == "inceptionGame" {
                if i == texts.count - 1 {
                    inceptionGame.alpha = 0.5
                }
            }
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        inceptionGame.alpha = 1
        
        let location = event.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        for node in touchedNodes.reversed() {
            if node.name == "inceptionGame" {
                if i == texts.count - 1 {
                    if let tutorial = Tutorial(fileNamed: "_Tutorial") {
                        let transition = SKTransition.flipVertical(withDuration: 1.0)
                        tutorial.scaleMode = .aspectFill
                        scene?.view?.presentScene(tutorial, transition: transition)
                    }
                }
            }
        }
    }
}
