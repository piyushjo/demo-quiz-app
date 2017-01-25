
import UIKit

import MobileCenterAnalytics
import MobileCenterCrashes

class Question2ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad();
        displayPlayerScore();
        
        // If the user has already played this
        //if (UserDefaults.standard.bool(forKey: "Q2Played") == true) {
        //    disableAllButtons();
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // MARK - Actions events
    @IBAction func incorrectAnswerProvided(_ sender: UIButton) {
        resultLabel.text = "INCORRECT";
        q2Played();
        
        // Send an event to track which which logo is the most difficult
        MSAnalytics.trackEvent("MarkedIncorrectAnswer", withProperties: ["Logo" : (self.logoImageView.accessibilityLabel)!]);
        
        // Send a test crash here
        if (MyGlobalVariables.playerScore == 0) {
            print(MyGlobalVariables.playerScore/MyGlobalVariables.playerScore);
        }
    }
    
    @IBAction func correctAnswerProvided(_ sender: UIButton) {
        resultLabel.text = "CORRECT";
        updateAndShowScore();
        q2Played();
    }
    
    // MARK - Other functions
    func q2Played() {
        UserDefaults.standard.set(true, forKey: "Q2Played");
        disableAllButtons();
    }
    
    func updateAndShowScore() {
        MyGlobalVariables.playerScore += 10;
        displayPlayerScore();
    }
    
    func displayPlayerScore(){
        currentScoreLabel.text = "Your score : " + String(MyGlobalVariables.playerScore);
    }
    
    func disableAllButtons() {
        answer1Button.isEnabled = false;
        answer2Button.isEnabled = false;
        answer3Button.isEnabled = false;
    }
}
