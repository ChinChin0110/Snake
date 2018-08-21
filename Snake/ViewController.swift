//
//  ViewController.swift
//  Snake
//
//  Created by Robin chin on 2018/8/20.
//  Copyright © 2018年 Robin chin. All rights reserved.
//

import UIKit

let playgroundWidth: Int = 20

class ViewController: UIViewController {
    
    private lazy var playground: Playground = {
        let playground = Playground(playgroundWidth: playgroundWidth)
        let width = UIScreen.main.bounds.width * 0.8
        playground.frame = CGRect(origin: .zero, size: CGSize(width: width, height: width))
        playground.center = view.center
        playground.isHidden = true
        view.addSubview(playground)
        return playground
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton.init()
        button.frame = CGRect.init(origin: .zero, size: CGSize.init(width: 100, height: 50))
        button.center = view.center
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 5
        view.addSubview(button)
        return button
    }()
    
    private var snakeModel = SnakeModel(playgroundWidth: playgroundWidth)
    private var currentFruit: Point = Point(x: 0, y: 0)
    private var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [UISwipeGestureRecognizerDirection.right,
         UISwipeGestureRecognizerDirection.left,
         UISwipeGestureRecognizerDirection.up,
         UISwipeGestureRecognizerDirection.down].forEach { (direction) in
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureHandler(sender:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
        startButton.addTarget(self, action: #selector(self.startButtonHandler), for: .touchUpInside)
    }
    
    @objc func gestureHandler(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            snakeModel.changeDirection(.up)
        case .down:
            snakeModel.changeDirection(.down)
        case .left:
            snakeModel.changeDirection(.left)
        case .right:
            snakeModel.changeDirection(.right)
        default:
            break
        }
    }
    
    @objc func startButtonHandler() {
        
        playground.isHidden = false
        startButton.isHidden = true
        snakeModel.reset()
        startTimer()
        currentFruit = getFruit()
        playground.updateFruit(currentFruit)
    }
    
    private func getFruit() -> Point {
        while true {
            let randomX = Int(arc4random_uniform(UInt32(playgroundWidth)))
            let randomY = Int(arc4random_uniform(UInt32(playgroundWidth)))
            let point = Point(x: randomX, y: randomY)
            if !snakeModel.body.contains(point) {
                return point
            }
        }
    }
    
    private func updateSnakeAndPlayground() {
        snakeModel.move()
        playground.updateSnake(snakeModel.body)
        
        if snakeModel.isHeadTouchBody() {
            stopTimer()
            playground.isHidden = true
            startButton.isHidden = false
        }
        if snakeModel.isHeadTouch(point: currentFruit) {
            snakeModel.increaseBody()
            currentFruit = getFruit()
            playground.updateFruit(currentFruit)
        }
    }
    
    private func startTimer() {
        
        timer?.cancel()
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(500), leeway: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            self?.updateSnakeAndPlayground()
        }
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

