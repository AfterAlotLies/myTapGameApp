//
//  ViewController.swift
//  firstGameKenny
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreInGame: UILabel!
    @IBOutlet weak var playerHighscore: UILabel!
    
    @IBOutlet weak var playZone: UIView!
    @IBOutlet weak var movingImage: UIImageView!
    
    var timer : Timer = Timer()
    var highscore : Int = 0
    var timeRemaining : Int = 0
    var timerForMoving : Timer = Timer()
    var userScore : Int = 0
    var lastTap : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userHighscoreOnView = UserDefaults.standard.object(forKey: "highscore")
        if (userHighscoreOnView as? Int) != nil {
            playerHighscore.text = "Highscore: \(userHighscoreOnView!)"
            highscore = UserDefaults.standard.object(forKey: "highscore") as! Int
        } else {
            playerHighscore.text = "Highscore : 0"
        }
        timeRemaining = 10
        scoreInGame.text = "Score: 0"
        startTimer()
        createGestureRecognizer()
    }
    
    @IBAction func restartGame(_ sender: Any) {
        timer.invalidate()
        timerForMoving.invalidate()
        userScore = 0
        scoreInGame.text = "Score: \(userScore)"
        self.viewDidLoad()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeFunction), userInfo: nil, repeats: true)
        timerForMoving = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(displayImages), userInfo: nil, repeats: true)
    }
    
    @objc func timeFunction() {
        timerLabel.text = "\(timeRemaining)"
        timeRemaining -= 1
        if timeRemaining < 0 {
            timer.invalidate()
            timerForMoving.invalidate()
            showAlertMessage()
            userScore = 0
        }
    }
    
    @objc func displayImages() {

        let sizeWidthOfPlayingZone : CGFloat = playZone.bounds.width
        let sizeHeightOfPlayingZone : CGFloat = playZone.bounds.height
            
        let randomX : CGFloat = CGFloat(arc4random_uniform(UInt32(sizeWidthOfPlayingZone)))
        let randomY : CGFloat = CGFloat(arc4random_uniform(UInt32(sizeHeightOfPlayingZone)))
            
        movingImage.center = CGPoint(x: randomX, y: randomY)
    }
    
    func showAlertMessage() {
        let alert : UIAlertController = UIAlertController(title: "Игра окончена", message: "Игра окончена", preferredStyle: UIAlertController.Style.alert)
        let againButton : UIAlertAction = UIAlertAction(title: "Начать заново", style: UIAlertAction.Style.default) { UIAlertAction in
            self.viewDidLoad()
            if let userHighscore = UserDefaults.standard.object(forKey: "highscore") as? Int {
                self.playerHighscore.text = "Highscore: \(userHighscore)"
            }
        }
        let okButton : UIAlertAction = UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default) { UIAlertAction in
            if let userHighscore = UserDefaults.standard.object(forKey: "highscore") as? Int {
                self.playerHighscore.text = "Highscore: \(userHighscore)"
                self.movingImage.isUserInteractionEnabled = false
            }
        }
        alert.addAction(againButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createGestureRecognizer() {
        movingImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countScore))
        movingImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func countScore() {
        let now = Date()
        if let lastTimeTap = lastTap {
            if now.timeIntervalSince(lastTimeTap) < 0.7 {
                return
            } else {
                userScore += 1
                scoreInGame.text = "Score: \(userScore)"
            }
        }
        self.lastTap = now
        if userScore > highscore {
            highscore = userScore
            UserDefaults.standard.set(highscore, forKey: "highscore")
        }
    }
}

