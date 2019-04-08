import Foundation
import SpriteKit
import GameKit
import PlaygroundSupport

public class GameOver: SKScene, SKPhysicsContactDelegate {
    var platforms = [
        SKSpriteNode(imageNamed: "platform"),
        ]
    var yel: SKSpriteNode!
    var portal: SKSpriteNode!
    var teleport1: SKSpriteNode!

    let yelCategory: UInt32 = 0x1 << 2
    let portalCategory: UInt32 = 0x1 << 3
    let platformCategory: UInt32 = 0x1 << 10
    
    var originalYelPosition = CGPoint(x: 0, y: 0)
    var originalTeleport1Pos = CGPoint(x: 0, y: 0)
    
    public override func sceneDidLoad() {
        yel = childNode(withName: "//yel") as? SKSpriteNode
        portal = childNode(withName: "//portal") as? SKSpriteNode
        portal.name = "Portal"
        teleport1 = childNode(withName: "//teleport1") as? SKSpriteNode
        teleport1.name = "Teleport1"
        
        for i in 0 ..< platforms.count {
            platforms[i] = childNode(withName: "//platform\(i)") as! SKSpriteNode
            platforms[i].physicsBody = SKPhysicsBody(rectangleOf: platforms[i].size)
            platforms[i].physicsBody?.isDynamic = false
            platforms[i].physicsBody?.categoryBitMask = platformCategory
        }
        
        self.physicsWorld.contactDelegate = self
        
        yel.physicsBody = SKPhysicsBody(rectangleOf: yel.size)
        yel.physicsBody?.isDynamic = true
        yel.physicsBody?.categoryBitMask = yelCategory
        yel.physicsBody?.contactTestBitMask = portalCategory
        originalYelPosition = yel.position
        
        portal.physicsBody = SKPhysicsBody(circleOfRadius: portal.size.width / 2)
        portal.physicsBody?.isDynamic = true
        portal.physicsBody?.affectedByGravity = false
        portal.physicsBody?.categoryBitMask = portalCategory
        portal.physicsBody?.contactTestBitMask = yelCategory
        
        teleport1.physicsBody = SKPhysicsBody(circleOfRadius: teleport1.size.width / 2)
        teleport1.physicsBody?.isDynamic = true
        teleport1.physicsBody?.affectedByGravity = false
        teleport1.physicsBody?.categoryBitMask = portalCategory
        teleport1.physicsBody?.contactTestBitMask = yelCategory
        originalTeleport1Pos = teleport1.position
        
        configure(for: self)
        
        let goAway = SKAction.moveTo(x: size.width, duration: 10)
        runAction(goAway, on: yel)
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & yelCategory) != 0 && (secondBody.categoryBitMask & portalCategory) != 0 {
            yelDidCollideWithPortal(playerNode: firstBody.node as! SKSpriteNode, objectNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    public func yelDidCollideWithPortal(playerNode: SKSpriteNode, objectNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = objectNode.position
        self.addChild(explosion)
        
        self.run(SKAction.wait(forDuration: 0.5)) {
            explosion.removeFromParent()
        }
        
        if objectNode.name == "Portal" {
            objectNode.removeFromParent()
            if let thanksForPlaying = ThanksForPlaying(fileNamed: "_ThanksForPlaying") {
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                thanksForPlaying.scaleMode = .aspectFill
                scene?.view?.presentScene(thanksForPlaying, transition: transition)
            }
        }
        
        run(SKAction.playSoundFileNamed("EnterInPortal.wav", waitForCompletion: true))
    }
    
    public override func update(_ currentTime: TimeInterval) {
        teleport1.position = originalTeleport1Pos
        
        portal.zRotation += 0.05
        teleport1.zRotation += 0.05
        
        yel.zRotation = 0
    }
}
