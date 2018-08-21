//
//  SnakeTests.swift
//  SnakeTests
//
//  Created by Robin chin on 2018/8/20.
//  Copyright © 2018年 Robin chin. All rights reserved.
//

import XCTest

@testable import Snake
class SnakeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        XCTAssertTrue(snake.direction == .left)
        XCTAssertFalse(snake.isHeadTouchBody())
    }
    
    func testMove() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        
        snake.move()
        XCTAssertEqual(snake.body, [Point(x: 4, y: 5), Point(x: 5, y: 5)])
    }
    
    func testMoveOverBound() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.body, [Point(x: 9, y: 5), Point(x: 0, y: 5)])
    }
    
    func testChangeDirection() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        
        snake.changeDirection(.up)
        snake.move()
        
        XCTAssertEqual(snake.body, [Point(x: 5, y: 4), Point(x: 5, y: 5)])
    }
    
    func testChangeInvalidDirection() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        
        XCTAssertTrue(snake.direction == .left)
        
        snake.changeDirection(.right)
        XCTAssertTrue(snake.direction == .left)
        
        snake.changeDirection(.left)
        XCTAssertTrue(snake.direction == .left)
    }
    
    func testIncreaseBody() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        
        XCTAssert(snake.body.count == 2)
        
        snake.increaseBody(2)
        
        XCTAssert(snake.body.count == 4)
    }
    
    func testInvalidIncreaseBody() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        
        XCTAssert(snake.body.count == 2)
        
        snake.increaseBody(-2)
        
        XCTAssert(snake.body.count == 2)
    }
    
    func testIsHeadTouchBody() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        
        XCTAssertFalse(snake.isHeadTouchBody())
        
        snake.increaseBody()
        snake.increaseBody()
        
        snake.changeDirection(.up)
        snake.move()
        snake.changeDirection(.right)
        snake.move()
        snake.changeDirection(.down)
        snake.move()
        
        XCTAssertTrue(snake.isHeadTouchBody())
    }
    
    func testIsHeadTouchPoint() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        let fruit = Point.init(x: 3, y: 5)
        XCTAssertFalse(snake.isHeadTouch(point: fruit))
        
        snake.move()
        snake.move()
        
        XCTAssertTrue(snake.isHeadTouch(point: fruit))
    }
    
    func testReset() {
        let snake = SnakeModel.init(playgroundWidth: 10)
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        XCTAssertTrue(snake.direction == .left)
        
        snake.move()
        snake.changeDirection(.up)
        snake.move()
        
        XCTAssertEqual(snake.body, [Point(x: 4, y: 4), Point(x: 4, y: 5)])
        
        snake.reset()
        
        XCTAssertEqual(snake.body, [Point(x: 5, y: 5), Point(x: 6, y: 5)])
        XCTAssertTrue(snake.direction == .left)
    }
}
