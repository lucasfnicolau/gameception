import Foundation
import SpriteKit

public var goToRight: SKAction!
public var goToLeft: SKAction!
public var goUp: SKAction!

public func configure(for scene: SKScene) {
    goToLeft = SKAction.moveBy(x: -0.16 * scene.size.width, y: 0, duration: 0.5)
    goToRight = SKAction.moveBy(x: 0.16 * scene.size.width, y: 0, duration: 0.5)
    goUp = SKAction.applyImpulse(CGVector(dx: 0, dy: -500), duration: 0.5)
}

public func runAction(_ action: SKAction, on player: SKSpriteNode) {
    player.run(action)
}
