import SwiftUI

class ViewModel: ObservableObject {

    private var displayLink: CADisplayLink?

    @Published  var player: Player?
    @Published var obstacles = [Obstacle]()

    private var step = 0
    var score = 0

    var gameOver = false

    private var lastUpdateTime: TimeInterval = 0

    func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .current, forMode: .default)

        lastUpdateTime = displayLink?.timestamp ?? 0
    }

    @objc private func gameLoop(displayLink: CADisplayLink) {
        let currentTime = displayLink.timestamp
        let deltaTime = currentTime - lastUpdateTime

        // Update score every second
        if deltaTime >= 1.0 {
            score += 10
            lastUpdateTime = currentTime
        }

        // create an obstacle every 5s
        if step % (60 * 3) == 0 && self.obstacles.count < 10 {
            let obstacle = Obstacle(center: CGPoint(x: UIScreen.main.bounds.midX, y: CGFloat.random(in: 50 ..< UIScreen.main.bounds.maxY - 50)),
                    width: 100,
                    height: 100)
            self.obstacles.append(obstacle)
        }
        step += 1

        // move obstacles
        for index in 0 ..< obstacles.count {
            objectWillChange.send() // publish changes in model
            obstacles[index].move()

            if obstacles[index].checkScreenCollision() {
                obstacles[index].restart()
                score += 1
            }

            if obstacles[index].checkCollisionWith(self.player!.frame) {
                self.gameOver = true
                self.pause()
            }
        }
    }

    func createPlayer(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.player = Player(center: center, width: width, height: height)
    }

    func pause() {
        self.displayLink?.remove(from: .current, forMode: .default)
    }

}