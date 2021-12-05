//
//  ViewController.swift
//  CatchKennyGame
//
//  Created by ofkaan on 3.12.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var counter = 0
    var score = 0
    var currentHighScore = UserDefaults.standard.object(forKey: "highScore") as? Int
    var positionsX = [0.0]
    var positionsY = [0.0]
    var alert : UIAlertController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenHeight = self.view.frame.size.height
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        
        imageView.frame.size = CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.height/5)
        positionsX = [10.0, imageViewWidth, imageViewWidth*2]
        positionsY = [screenHeight/2 - imageViewHeight*1.5, screenHeight/2 - imageViewHeight*0.5, screenHeight/2 + imageViewHeight*0.5]
        
        alert = UIAlertController(title: "Time's Up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            self.imageView.isUserInteractionEnabled = false
        }
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
            self.startGame()
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        
        if currentHighScore != nil {
            highScoreLabel.text = "High Score: \(currentHighScore ?? 0)"
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        startGame()
    }
    
    @objc func imageClicked() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func countDown() {
        timeLabel.text = "\(counter)"
        counter -= 1
        changeImagePos()
        
        if counter < 0 {
            timer.invalidate()
            if currentHighScore == nil || score > currentHighScore! {
                saveHighScore()
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func changeImagePos() {
        imageView.frame.origin.x = positionsX[Int.random(in: 0...2)]
        imageView.frame.origin.y = positionsY[Int.random(in: 0...2)]
    }
    
    func saveHighScore(){
        currentHighScore = score
        highScoreLabel.text = "High Score: \(score)"
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    
    func startGame() {
        imageView.isUserInteractionEnabled = true
        counter = 10
        score = 0
        timeLabel.text = "\(counter)"
        scoreLabel.text = "Score: \(score)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
}

