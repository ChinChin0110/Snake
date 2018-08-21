//
//  SnakeModel.swift
//  Snake
//
//  Created by Robin chin on 2018/8/20.
//  Copyright © 2018年 Robin chin. All rights reserved.
//
import Foundation

class SnakeModel {
    private(set) var body: [Point] = []
    private(set) var direction: Direction = .left
    let playgroundWidth: Int
    
    init(playgroundWidth: Int = 10) {
        self.playgroundWidth = playgroundWidth >= 2 ? playgroundWidth : 10
        let center = playgroundWidth / 2
        let points = [Point(x: center, y: center), Point(x: center + 1, y: center)]
        self.body = points
    }
    
    func reset() {
        let center = playgroundWidth / 2
        let points = [Point(x: center, y: center), Point(x: center + 1, y: center)]
        body = points
        direction = .left
    }
    
    func move() {
        objc_sync_enter(body)
        let headPoint = body.first!
        var newHeadPoint = body.popLast()!
        
        switch direction {
        case .up:
            newHeadPoint.x = headPoint.x
            newHeadPoint.y = headPoint.y - 1
        case .down:
            newHeadPoint.x = headPoint.x
            newHeadPoint.y = headPoint.y + 1
        case .left:
            newHeadPoint.x = headPoint.x - 1
            newHeadPoint.y = headPoint.y
        case .right:
            newHeadPoint.x = headPoint.x + 1
            newHeadPoint.y = headPoint.y
        }
        checkIsOverBounds(&newHeadPoint)
        body.insert(newHeadPoint, at: 0)
        objc_sync_exit(body)
    }
    
    func increaseBody(_ length: Int = 2) {
        guard length > 0 else { return }
        objc_sync_enter(body)
        let newBodys = Array(repeating: body.last!, count: length)
        body.append(contentsOf: newBodys)
        objc_sync_exit(body)
    }
    
    func isHeadTouchBody() -> Bool {
        var _body = body
        let head = _body.remove(at: 0)
        return _body.contains(head)
    }
    
    func isHeadTouch(point: Point) -> Bool {
        var _body = body
        let head = _body.remove(at: 0)
        return head.x == point.x && head.y == point.y
    }
    
    func changeDirection(_ direction: Direction) {
        switch self.direction {
        case .up, .down:
            if direction == .up || direction == .down {
                break
            }
            self.direction = direction
        case .left, .right:
            if direction == .left || direction == .right {
                break
            }
            self.direction = direction
        }
    }
    
    private func checkIsOverBounds(_ point: inout Point) {
        if point.x < 0 {
            point.x = playgroundWidth - 1
        } else if point.x > playgroundWidth - 1 {
            point.x = 0
        }
        
        if point.y < 0 {
            point.y = playgroundWidth - 1
        } else if point.y > playgroundWidth - 1 {
            point.y = 0
        }
    }
}

enum Direction {
    case up, down, right, left
}

struct Point: Equatable {
    var x: Int
    var y: Int
}
