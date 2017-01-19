
import UIKit
import WebKit
import Foundation

import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Cleanup any local variables from last play
        //cleanupLocalStorage();
        
        // STEP 1
        // Mobile Center: Identity -> Show a Facebook login button programmatically
        let loginButton = LoginButton(readPermissions: [ .publicProfile ]);
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        loginButton.center = view.center;
        loginButton.delegate = self;
        view.addSubview(loginButton);
        
        // If there is already an FB access token, skip FB sign in
        if (AccessToken.current != nil) {
            loginToAzureMobileApps();
        }
        
        // Register a notification to get profile changes to display user name after FB auth
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange,
            object: nil, queue: nil) { (Notification) in
                
                if let profile = FBSDKProfile.current(),
                    let playerName = profile.firstName {
                        let defaults = UserDefaults.standard;
                        defaults.set(playerName, forKey: "playerName");
                }
        }
    }

    func loginToAzureMobileApps() {
        
        // STEP 3
        // Mobile Center: Identity -> Pass the authentication token 
        //  retrieved from Facebook to Azure Mobile backend
        let payload: [String: String] = ["access_token":
            (AccessToken.current?.authenticationToken)!];
        
        MyGlobalVariables.azureMobileClient.login(withProvider: "facebook", token: payload) { (user, error) in
            
            if ((error) != nil) {
                print("Failed Azure Mobile login with error: %@" + error.debugDescription);
            } else {
                print("Completed Azure Mobile login as user: " + (user?.userId)!);
                
                // Enable the Play button
                self.playButton.isEnabled = true;
            }
        };
    }
    
    func logoutFromAzureMobileApps() {
        
        // Logout from Azure Mobile Apps
        MyGlobalVariables.azureMobileClient.logout { (error) in
            if ((error) != nil) {
                print("Failed Azure Mobile logout with error: %@" + error.debugDescription);
            } else {
                print("Completed Azure Mobile logout");
            }
        }
    }
    
    func cleanupLocalStorage() {
        
        // Cleanup NSUSerDefaults
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: LoginButtonDelegate {
    
    // STEP 2 
    // Mobile Center: Identity -> When the player 
    //  logs in successully then login to Azure Mobile Apps
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if (AccessToken.current != nil) {
            print("Completed FB login via LoginButton");
            
            // After signing into Facebook, use the creds to sign 
            //  in to Azure Mobile Apps for data segregation
            loginToAzureMobileApps();
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Completed FB logout via LoginButton");
        
        // Disable the Play button
        self.playButton.isEnabled = false;

        // Cleanup variables stored locally
        cleanupLocalStorage();
        
        // Logout from Azure Mobile Apps
        logoutFromAzureMobileApps();
    }
}

