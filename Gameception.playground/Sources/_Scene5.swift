import Foundation
import SpriteKit
import GameKit
import PlaygroundSupport

public class Scene5: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var platforms = [
        SKSpriteNode(imageNamed: "platform"),
        SKSpriteNode(imageNamed: "platform"),
        SKSpriteNode(imageNamed: "platform"),
        ]
    var yel: SKSpriteNode!
    var portal: SKSpriteNode!
    var teleport0: SKSpriteNode!
    var teleport1: SKSpriteNode!
    
    var shouldTeleport = false
    
    var collectableObjects = [
        "RightArrow",
        "LeftArrow",
        "UpArrow"
    ]
    var gameTimer: Timer!
    
    let collectableObjectCategory: UInt32 = 0x1 << 1
    let playerCategory: UInt32 = 0x1 << 0
    let yelCategory: UInt32 = 0x1 << 2
    let portalCategory: UInt32 = 0x1 << 3
    let platformCategory: UInt32 = 0x1 << 10
    
    var originalYelPosition = CGPoint(x: 0, y: 0)
    var originalTeleport0Pos = CGPoint(x: 0, y: 0)
    var originalTeleport1Pos = CGPoint(x: 0, y: 0)
    
    public override func sceneDidLoad() {
        player = childNode(withName: "//player") as? SKSpriteNode
        yel = childNode(withName: "//yel") as? SKSpriteNode
        portal = childNode(withName: "//portal") as? SKSpriteNode
        portal.name = "Portal"
        teleport0 = childNode(withName: "//teleport0") as? SKSpriteNode
        teleport0.name = "Teleport0"
        teleport1 = childNode(withName: "//teleport1") as? SKSpriteNode
        teleport1.name = "Teleport1"
        
        for i in 0 ..< platforms.count {
            platforms[i] = childNode(withName: "//platform\(i)") as! SKSpriteNode
            platforms[i].physicsBody = SKPhysicsBody(rectangleOf: platforms[i].size)
            platforms[i].physicsBody?.isDynamic = false
            platforms[i].physicsBody?.categoryBitMask = platformCategory
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(spawn), userInfo: nil, repeats: true)
        
        self.physicsWorld.contactDelegate = self
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = collectableObjectCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        
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
        
        teleport0.physicsBody = SKPhysicsBody(circleOfRadius: teleport0.size.width / 2)
        teleport0.physicsBody?.isDynamic = true
        teleport0.physicsBody?.affectedByGravity = false
        teleport0.physicsBody?.categoryBitMask = portalCategory
        teleport0.physicsBody?.contactTestBitMask = yelCategory
        originalTeleport0Pos = teleport0.position
        
        teleport1.physicsBody = SKPhysicsBody(circleOfRadius: teleport1.size.width / 2)
        teleport1.physicsBody?.isDynamic = true
        teleport1.physicsBody?.affectedByGravity = false
        teleport1.physicsBody?.categoryBitMask = portalCategory
        teleport1.physicsBody?.contactTestBitMask = yelCategory
        originalTeleport1Pos = teleport1.position
        
        configure(for: self)
        runAction(goUp, on: yel)
    }
    
    @objc func spawn() {
        collectableObjects = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: collectableObjects) as! [String]
        
        let object = CollectableObject(texture: SKTexture(imageNamed: collectableObjects[0]))
        object.id = collectableObjects[0]
        
        switch object.id {
        case "LeftArrow",
             "RightArrow":
            resizeByWidth(object, newWidth: 0.05 * size.width)
        case "UpArrow",
             "DownArrow":
            resizeByHeight(object, newHeight: 0.05 * size.width)
        default:
            return
        }
        
        let randomObjectPosition = GKRandomDistribution(lowestValue: (-Int(size.width) / 2 + Int(object.size.width) / 2), highestValue: -Int(object.size.width) / 2)
        let position = CGFloat(randomObjectPosition.nextInt())
        
        object.position = CGPoint(x: position, y: size.height)
        
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
        object.physicsBody?.isDynamic = true
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.categoryBitMask = collectableObjectCategory
        object.physicsBody?.contactTestBitMask = playerCategory
        object.physicsBody?.collisionBitMask = 0
        
        self.addChild(object)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        object.run(SKAction.sequence(actionArray))
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
        
        if (firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & collectableObjectCategory) != 0 {
            playerDidCollideWithObject(playerNode: firstBody.node as! SKSpriteNode, objectNode: secondBody.node as! SKSpriteNode)
        }
        
        if (firstBody.categoryBitMask & yelCategory) != 0 && (secondBody.categoryBitMask & portalCategory) != 0 {
            yelDidCollideWithPortal(playerNode: firstBody.node as! SKSpriteNode, objectNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    public func playerDidCollideWithObject(playerNode: SKSpriteNode, objectNode: SKSpriteNode) {
        
        if let object = objectNode as? CollectableObject {
            switch object.id {
            case "RightArrow":
                runAction(goToRight, on: yel)
            case "LeftArrow":
                runAction(goToLeft, on: yel)
            case "UpArrow":
                runAction(goUp, on: yel)
            default:
                return
            }
        }
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = objectNode.position
        self.addChild(explosion)
        
        if objectNode == yel {
            respawnPerson()
        } else {
            objectNode.removeFromParent()
            self.run(SKAction.wait(forDuration: 0.5)) {
                explosion.removeFromParent()
            }
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
            if let scene6 = Scene6(fileNamed: "_Scene6") {
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                scene6.scaleMode = .aspectFill
                scene?.view?.presentScene(scene6, transition: transition)
            }
        } else if objectNode.name == "Teleport0" {
            shouldTeleport = true
        }
        
        run(SKAction.playSoundFileNamed("EnterInPortal.wav", waitForCompletion: true))
    }
    
    public override func update(_ currentTime: TimeInterval) {
        teleport0.position = originalTeleport0Pos
        teleport1.position = originalTeleport1Pos
        
        portal.zRotation += 0.05
        teleport0.zRotation += 0.05
        teleport1.zRotation += 0.05
        
        yel.zRotation = 0
        
        if !shouldTeleport {
            if yel.position.y < -size.height {
                respawnPerson()
            }
        } else {
            yel.position = teleport1.position
            shouldTeleport = false
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let pos = event.location(in: self)
        if pos.x >= -size.width / 2 && pos.x <= 0 {
            player.position.x = pos.x
        }
    }
    
    func respawnPerson() {
        yel.position = originalYelPosition
        yel.zRotation = 0
    }
}
