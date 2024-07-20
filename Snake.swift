import SpriteKit

class Snake {
    var segments: [SKSpriteNode] = []
    var scene: SKScene!
    
    init(scene: SKScene) {
        self.scene = scene
        createSnake()
    }
    
    func createSnake() {
        let head = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
        head.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        head.name = "head"
        scene.addChild(head)
        segments.append(head)
    }
    
    func move(_ direction: Direction) {
        // Move the snake by adding a new head and removing the tail
        let head = segments.first!
        let newHead = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
        
        switch direction {
        case .up:
            newHead.position = CGPoint(x: head.position.x, y: head.position.y + 10)
        case .down:
            newHead.position = CGPoint(x: head.position.x, y: head.position.y - 10)
        case .left:
            newHead.position = CGPoint(x: head.position.x - 10, y: head.position.y)
        case .right:
            newHead.position = CGPoint(x: head.position.x + 10, y: head.position.y)
        }
        
        newHead.name = "head"
        scene.addChild(newHead)
        segments.insert(newHead, at: 0)
        
        // Remove the tail
        let tail = segments.last!
        tail.removeFromParent()
        segments.removeLast()
    }
    
    func checkSelfCollision() -> Bool {
        let head = segments.first!
        for segment in segments.dropFirst() {
            if head.intersects(segment) {
                return true
            }
        }
        return false
    }
    
    func grow() {
        // Create a new segment at the tail end of the snake
        let tail = segments.last!
        let newSegment = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
        newSegment.position = tail.position
        newSegment.name = "segment"
        scene.addChild(newSegment)
        segments.append(newSegment)
    }
    
    var head: SKSpriteNode {
        return segments.first!
    }
    
    func removeAllSegments() {
        for segment in segments {
            segment.removeFromParent()
        }
        segments.removeAll()
    }
}
