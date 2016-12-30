
import UIKit

import FBSDKCoreKit
import MobileCenterAnalytics

class CategoriesViewController: UIViewController {

    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    @IBOutlet weak var lastScoreLabelField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Loads the player's current score
        getAndDisplayPlayerLastScore();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Actions events
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        // Send an event to track which is the most commonly played category of logos
        MSAnalytics.trackEvent("SelectedCategory", withProperties: ["Category" : sender.currentTitle!]);
    }
    
    @IBAction func unwindtoCategories(sender: UIStoryboardSegue) {
        if sender.source is Question3ViewController {
            self.lastScoreLabelField.text = "Your score in this game was: " + String(MyGlobalVariables.playerScore);
            
            // Update this score in the backend also
            updatePlayerScore();
        }
    }
    
    func getAndDisplayPlayerLastScore() {
        let table = MyGlobalVariables.azureMobileClient.table(withName: "LastPlayedScore");
        
        // Query the LastPlayedScore table
        table.read { (result, error) in
            if let err = error {
                print("Azure Mobile Apps: Error in connecting to the table: ", err)
            } else if (result?.items) != nil && (result?.items?.count)! > 0 {
                // If table access was succesful and an item was found
                let playerRecord = result?.items?[0];
                let playerLastScore = (String(format: "%@", playerRecord?["score"] as! CVarArg) as String);
                
                // Display the last played score using the FB name if available
                let defaults = UserDefaults.standard;
                if let playerName = defaults.string(forKey: "playerName") {
                    self.welcomeMessageLabel.text = String(format: "Welcome back, %@!", playerName);
                }
                else {
                    self.welcomeMessageLabel.text = String(format: "Welcome back!");
                }
                self.lastScoreLabelField.text = String(format: "Your last score was: %@", playerLastScore);
            } else {
                // No score found. Playing for the first time
                let defaults = UserDefaults.standard;
                if let playerName = defaults.string(forKey: "playerName") {
                    self.welcomeMessageLabel.text = String(format: "Welcome, %@!", playerName);
                }
                else {
                    self.welcomeMessageLabel.text = String(format: "Welcome!");
                }
            }
        }
    }
    
    func updatePlayerScore() {
        let table = MyGlobalVariables.azureMobileClient.table(withName: "LastPlayedScore");
        let userId = MyGlobalVariables.azureMobileClient.currentUser?.userId;

        // Query the LastPlayedScore table
        table.read { (result, error) in
            if let err = error {
                print("Azure Mobile Apps: Error in connecting to the table: ", err)
            } else if (result?.items) != nil && (result?.items?.count)! > 0 {
                // If table access was succesful and an item was found

                // Update
                print("Azure Mobile Apps: Player record found.");
                
                let playerRecord = result?.items?[0];
                let playerRecordId = playerRecord?["id"];
                
                table.update(["id": playerRecordId!, "score": MyGlobalVariables.playerScore]) { (result, error) in
                    if let err = error {
                        print("Azure Mobile Apps: Error in updating player record:", err);
                    } else if let item = result {
                        print("Azure Mobile Apps: Updated score to", item["score"]!, "for player", userId ?? "" );
                    }
                }
            } else {
                // Insert
                print("Azure Mobile Apps: Player record not found.");
                
                let newItem = ["score": MyGlobalVariables.playerScore]
                table.insert(newItem) { (result, error) in
                    if let err = error {
                        print("Azure Mobile Apps: Error in inserting player record:", err);
                    } else if let item = result {
                        print("Azure Mobile Apps: Score inserted", item["score"]!, "for player", userId ?? "" );
                    }
                }
            }
        }
    }
}
