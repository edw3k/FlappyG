import SwiftUI
import AVFoundation
import  CoreGraphics
import Foundation
class ViewModel: ObservableObject {

    private var displayLink: CADisplayLink?

    @Published  var player: Player?
    @Published var obstacles = [Obstacle]()

    private var step = 0
    var score = 0
    private var currentLevel: GameLevel = .Easy
    var gameOver = false
    @Published var gameWon = false
    private var lastUpdateTime: TimeInterval = 0
    private var audioPlayer: AVAudioPlayer?
    @Published private var isPlaying: Bool = false

    init() {
        setUpSounds()
    }


    func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .current, forMode: .default)

        lastUpdateTime = displayLink?.timestamp ?? 0
    }


    enum GameLevel {
        case Easy
        case Hard
    }

    func updateLevel() {
        if score >= 100 && currentLevel == .Easy {
            currentLevel = .Hard
            // Adjust the obstacle creation frequency for the hard level
            createObstacle()
        }
    }

    private func createObstacle() {
        var obstacleSpeedRange: ClosedRange<CGFloat>
        if currentLevel == .Easy {
            obstacleSpeedRange = 1...3
        } else {
            obstacleSpeedRange = 100...110
        }

        let obstacle = Obstacle(center: CGPoint(x: -50, y: CGFloat.random(in: 50..<UIScreen.main.bounds.maxY-50)), width: 100, height: 100)
        obstacle.speed = CGFloat.random(in: obstacleSpeedRange)
        self.obstacles.append(obstacle)
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
            let obstacleCenterX: CGFloat = (currentLevel == .Easy) ? -50 : UIScreen.main.bounds.midX
            let obstacle = Obstacle(center: CGPoint(x: obstacleCenterX, y: CGFloat.random(in: 50 ..< UIScreen.main.bounds.maxY - 50)),
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

        if score >= 200 {
            gameWon = true
            pause()
        }
    }


    func createPlayer(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.player = Player(center: center, width: width, height: height)
    }

    func restartGame() {
        self.player = nil
        self.obstacles.removeAll()
        self.step = 0
        self.score = 0
        self.gameOver = false
        createPlayer(center: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 100), width: 50, height: 50)
        createDisplayLink()
        gameWon = false
    }

    func pause() {
        self.displayLink?.remove(from: .current, forMode: .default)
    }
    private func setUpSounds() {
        if let soundURL = Bundle.main.url(forResource: "cancion", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops  = Int(-10)
            } catch {
                fatalError("AVAudioPlayer error")
            }
        }
    }

    func playSound() {
        audioPlayer?.play()
        isPlaying = true
    }

    func pauseSound() {
        audioPlayer?.pause()
        isPlaying = false
    }

    // Toggle usado para mostrar el pause en breathing
    func isSound() -> Bool {
        return isPlaying
    }
}
