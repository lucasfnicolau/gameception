import Foundation
import SpriteKit
import PlaygroundSupport

public class CollectableObject: SKSpriteNode {
    public var objName = ""
    public var id = ""
    public var action: SKAction!
    public var category: UInt32 = 0x1 << 1
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
    
    public init(texture: SKTexture?) {
        super.init(texture: texture, color: NSColor.clear, size: texture?.size() ?? CGSize(width: 100, height: 100))
    }
    
    public init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, color: NSColor.clear, size: size)
    }
}
