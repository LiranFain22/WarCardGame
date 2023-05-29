import UIKit
import CoreLocation


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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUsernameSaved()
        
        configureAlertController(alertController: alertController)
        
        configureLocation()
        
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
    
    func configureLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showImageDirectionByRandomPoint() {
        if (isPointLeftOfPhone(point: getlocation())) {
            // Point is in Left half side, show West direction image
            westImage.isHidden = false
            eastImage.isHidden = true
            
            isLeftSide = true
        } else {
            // Point is in Right half side, show East direction image
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

extension MenuController: CLLocationManagerDelegate {
    
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
    
    func getlocation() -> CGPoint {
        // Set default latitude and longitude values
        let latitude = 37.7749
        let longitude = -122.4194
        
        let point = CGPoint(x: latitude, y: longitude)
        
        return point
    }
    
    func isPointLeftOfPhone(point: CGPoint) -> Bool {
        guard let currentLocation = locationManager.location else {
            // Location information is unavailable, default to left side
            return true
        }
        
        let currentLongitude = currentLocation.coordinate.longitude
        
        return point.y < currentLongitude
    }
}
