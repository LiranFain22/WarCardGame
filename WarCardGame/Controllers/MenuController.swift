import UIKit

class MenuController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var westImage: UIImageView!
    @IBOutlet weak var eastImage: UIImageView!
    
    let alertController = UIAlertController(title: "Enter User Name", message: nil, preferredStyle: .alert)
    
    var userNameEntered: ((String) -> Void)?
    var userNameOK: Bool = false
    var userName: String?
    
    var isLeftSide: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUsernameSaved()
        
        configureAlertController(alertController: alertController)
        
        showImageDirectionByRandomPoint()
    }
    
    @IBAction func EnterNamePressed(_ sender: UIButton) {
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func StartPressed(_ sender: UIButton) {
        if (userNameOK) {
            performSegue(withIdentifier: "toGame", sender: self)
        } else {
            self.displayErrorMessage(message: "Please enter a user name.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            if let destinationVC = segue.destination as? GameViewController,
               let saveUserName = userName {
                // Pass data to the GameViewController
                destinationVC.userEnteredName = saveUserName
                destinationVC.isLeftSide = isLeftSide ?? true
            }
        }
    }
}

//MARK: - Config Section

extension MenuController {
    func configureAlertController(alertController: UIAlertController) {
        // Add a text field to the alert controller
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        // Create an "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Handle the user's input
            if let userName = alertController.textFields?.first?.text {
                
                let characterRegex = "^[a-zA-Z]+$"
                let characterTest = NSPredicate(format: "SELF MATCHES %@", characterRegex)
                
                if userName.isEmpty {
                    // Error message if the user name is empty
                    self.displayErrorMessage(message: "Please enter a user name.")
                } else if !characterTest.evaluate(with: userName) {
                    // Error message if the user name contains non-alphabetic characters
                    self.displayErrorMessage(message: "User name can only contain alphabetic characters.")
                } else {
                    // Valid user input
                    self.userNameOK = true
                    self.userNameLabel.text = "Hi \(userName)!"
                    self.userNameEntered?(userName)
                    self.userName = userName
                    
                    // Save username in UserDefaults
                    UserDefaults.standard.set(userName, forKey: "username")
                    
                    // Show the label and hide the button
                    self.userNameLabel.isHidden = false
                    self.userNameButton.isHidden = true
                }
            }
        }
        
        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
    }
    
    func showImageDirectionByRandomPoint() {
        if (isPointInLeftHalfOfScreen(point: getRandomPointOnScreen())) {
            // Point is in Left half side of screen, show West direction image
            westImage.isHidden = false
            eastImage.isHidden = true
            
            isLeftSide = true
        } else {
            // Point is in Right half side of screen, show East direction image
            westImage.isHidden = true
            eastImage.isHidden = false
            
            isLeftSide = false
        }
    }
    
    func displayErrorMessage(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okErrorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okErrorAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
}

//MARK: - Additional functions

extension MenuController {
    
    func checkUsernameSaved() {
        // Check if username is saved in UserDefaults
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            // Username exists, show the label and hide the button
            userNameLabel.text = "Hi \(savedUsername)!"
            userNameLabel.isHidden = false
            userNameButton.isHidden = true
            userName = savedUsername
            self.userNameEntered?(savedUsername)
            userNameOK = true
        } else {
            // Username doesn't exist, hide the label and show the button
            userNameLabel.isHidden = true
            userNameButton.isHidden = false
        }
    }
    
    func getRandomPointOnScreen() -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let randomX = CGFloat.random(in: 0..<screenWidth)
        let randomY = CGFloat.random(in: 0..<screenHeight)
        
        let point = CGPoint(x: randomX, y: randomY)
        
        return point
    }
    
    func isPointInLeftHalfOfScreen(point: CGPoint) -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        return point.x < screenWidth / 2
    }
}
