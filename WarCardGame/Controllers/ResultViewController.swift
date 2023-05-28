import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var score1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var score2Label: UILabel!
    
    var winnerName: String?
    var player1Name: String?
    var score1: String?
    var player2Name: String?
    var score2: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureResult()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureResult() {
        winnerLabel.text = winnerName
        player1Label.text = player1Name
        score1Label.text = score1
        player2Label.text = player2Name
        score2Label.text = score2
    }
    
    @IBAction func returnHomePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
}
