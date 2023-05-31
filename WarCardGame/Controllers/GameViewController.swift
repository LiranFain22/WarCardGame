import UIKit

class GameViewController: UIViewController {
    
    let menuController = MenuController()
    var userEnteredName: String = "Player"
    var isLeftSide: Bool = false
    let cardImages = ["card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13"]
    var score1:Int = 0
    var score2:Int = 0
    
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    
    @IBOutlet weak var leftCardImage: UIImageView!
    @IBOutlet weak var rightCardImage: UIImageView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
        
        getDataFromMenuController()
        
        setPlayersPositions()
        
        startGame()
    }
    
    func getDataFromMenuController() {
        if let safeUsername = menuController.userName {
            userEnteredName = safeUsername
        }
        if let safeIsLeftSide = menuController.isLeftSide {
            isLeftSide = safeIsLeftSide
        }
    }
    
    func setPlayersPositions() {
        if (isLeftSide) {
            // set Player in left position, and Computer in right position
            player1NameLabel.text = userEnteredName
            player1ScoreLabel.text = String(format: "%d", score1)
            player2NameLabel.text = "COMPUTER"
            player2ScoreLabel.text = String(format: "%d", score2)
        } else {
            // set Computer in left position, and Player in right position
            player1NameLabel.text = "COMPUTER"
            player1ScoreLabel.text = String(format: "%d", score1)
            player2NameLabel.text = userEnteredName
            player2ScoreLabel.text = String(format: "%d", score2)
            
        }
    }
    
    func startGame() {
        timerLabel.isHidden = false
        playTurn(turn: 0)
    }
    
    func playTurn(turn: Int) {
        if turn < 10 {
            var secondsLeft = 3
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                // Update timer label with remaining seconds
                if secondsLeft > 0 {
                    self.timerLabel.text = "🕑 \(secondsLeft) sec"
                } else {
                    self.timerLabel.text = ""
                }
                
                secondsLeft -= 1
                
                if secondsLeft < 0 {
                    timer.invalidate()
                    
                    // Generate random card indices for both players
                    let leftCardIndex = Int.random(in: 0..<self.cardImages.count)
                    let rightCardIndex = Int.random(in: 0..<self.cardImages.count)
                    
                    // Update the card images
                    self.leftCardImage.image = UIImage(named: self.cardImages[leftCardIndex])
                    self.rightCardImage.image = UIImage(named: self.cardImages[rightCardIndex])
                    
                    // Game logic based on the card values
                    if leftCardIndex > rightCardIndex {
                        self.score1 += 1
                        // Update Left Score
                        self.player1ScoreLabel.text = String(format: "%d", self.score1)
                    } else if rightCardIndex > leftCardIndex {
                        self.score2 += 1
                        // Update Right Score
                        self.player2ScoreLabel.text = String(format: "%d", self.score2)
                    }
                    
                    // Calling playTurn recursively for the next turn
                    self.playTurn(turn: turn + 1)
                }
            }
        } else {
            // Game finished, Move to Result Screen
            performSegue(withIdentifier: "toResult", sender: self)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            if let destinationVC = segue.destination as? ResultViewController {
                if score1 > score2 {
                    destinationVC.winnerName = player1NameLabel.text
                } else if score2 > score1 {
                    destinationVC.winnerName = player2NameLabel.text
                } else {
                    destinationVC.winnerName = "Draw!"
                }
                destinationVC.player1Name = player1NameLabel.text
                destinationVC.player2Name = player2NameLabel.text
                destinationVC.score1 = String(format: "%d", score1)
                destinationVC.score2 = String(format: "%d", score2)
            }
        }
    }
    
}
