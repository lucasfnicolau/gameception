import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 640 * 1.3, height: 480 * 1.3))
if let scene = MainMenu(fileNamed: "_MainMenu") {
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

