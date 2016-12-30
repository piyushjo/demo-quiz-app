
import UIKit
import WebKit
import Foundation

import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    var store : MSCoreDataStore?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // FB Login
        let loginButton = LoginButton(readPermissions: [ .publicProfile ]);
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        loginButton.center = view.center;
        loginButton.delegate = self;
        view.addSubview(loginButton);
        
        // If there is already an FB access token, skip FB sign in
        if (AccessToken.current != nil) {
            loginToAzureMobileApps();
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange,
            object: nil, queue: nil) { (Notification) in
                
                if let profile = FBSDKProfile.current(),
                    let playerName = profile.firstName {
                        let defaults = UserDefaults.standard;
                        defaults.set(playerName, forKey: "playerName");
                }
        }

        // Initialization for Azure Mobile Apps Data sync
        initializeLocalStorageDb();
    }
    
    func initializeLocalStorageDb() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!;
        self.store = MSCoreDataStore(managedObjectContext: managedObjectContext);
        MyGlobalVariables.azureMobileClient.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil);
    }
    
    func loginToAzureMobileApps() {
        let payload: [String: String] = ["access_token": (AccessToken.current?.authenticationToken)!];
        
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
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        print("Completed FB login via LoginButton");
        
        // After signing into Facebook, use the creds to sign in to Azure Mobile Apps for data segregation
        loginToAzureMobileApps();
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Completed FB logout via LoginButton");
        
        // Disable the Play button
        self.playButton.isEnabled = false;
        
        // Cleanup NSUSerDefaults
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        
        // Logout from Azure Mobile Apps
        logoutFromAzureMobileApps();
    }
}

