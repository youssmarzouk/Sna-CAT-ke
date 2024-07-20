import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var snake: Snake!
    var food: SKSpriteNode!
    var direction: Direction = .right
    var currentInterval: TimeInterval = 0.15
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Initialize snake
        snake = Snake(scene: self)
        
        // Initialize food
        spawnFood()
        
        // Set up physics
        physicsWorld.gravity = .zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Start the game loop
        startGame()
    }
    
    func startGame() {
        let moveAction = SKAction.run {
            self.snake.move(self.direction)
            if self.checkCollision() {
                self.endGame()
            }
        }
        let intervalAction = SKAction.wait(forDuration: currentInterval)
        let sequenceAction = SKAction.sequence([moveAction, intervalAction])
        run(SKAction.repeatForever(sequenceAction))
    }
    
    func endGame() {
        removeAllActions()
        snake.removeAllSegments()
        
        // Optionally, show game over screen or restart button
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameOverLabel)
    }
    
    func spawnFood() {
        let randX = CGFloat.random(in: 1...size.width - 1)
        let randY = CGFloat.random(in: 1...size.height - 1)
        
        food = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 10))
        food.position = CGPoint(x: randX, y: randY)
        food.name = "food"
        
        addChild(food)
    }
    
    func checkCollision() -> Bool {
        if snake.checkSelfCollision() {
            return true
        }
        
        // Check collision with food
        if snake.head.intersects(food) {
            snake.grow()
            spawnFood()
        }
        
        return false
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastUpdateTime
        
        if delta >= currentInterval {
            lastUpdateTime = currentTime
            // Handle user inputs here if needed
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        if touchLocation.x > size.width / 2 {
            // Right side of the screen, change direction clockwise
            direction = direction.clockwise()
        } else {
            // Left side of the screen, change direction counterclockwise
            direction = direction.counterclockwise()
        }
    }
}
