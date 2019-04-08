import Foundation
import SpriteKit
import PlaygroundSupport

public func resizeByWidth(_ object: SKSpriteNode, newWidth width: CGFloat) {
    let oldWidth: CGFloat = object.size.width
    object.size.width = width
    object.size.height = object.size.height * object.size.width / oldWidth
}

public func resizeByHeight(_ object: SKSpriteNode, newHeight height: CGFloat) {
    let oldHeight: CGFloat = object.size.height
    object.size.height = height
    object.size.width = object.size.width * object.size.height / oldHeight
}
