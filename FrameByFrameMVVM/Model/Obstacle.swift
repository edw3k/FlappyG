import Foundation
import SwiftUI

class Obstacle: Sprite, Identifiable {
    let id = UUID()
    var speed: CGFloat

    override init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.speed = CGFloat.random(in: 3...6)
        super.init(center: center, width: width, height: height)
    }

    func move() {
        withAnimation {
            self.center.x -= speed // Move horizontally (to the left)
        }
    }

    // After obstacle position < xMin: restart obstacle position and speed
    func restart() {
        self.center.x = UIScreen.main.bounds.maxX // Set obstacle position to the rightmost edge
        self.center.y = CGFloat.random(in: 50..<UIScreen.main.bounds.maxY - 50)
        self.speed = CGFloat.random(in: 3...6)
    }
}