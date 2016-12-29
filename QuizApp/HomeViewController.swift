
import UIKit
import WebKit

import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    var store : MSCoreDataStore?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // FB Login
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ]);
        loginButton.center = view.center;
        loginButton.delegate = self;
        view.addSubview(loginButton);
        
        // If there is already an FB access token, skip FB sign in
        if (AccessToken.current != nil) {
            loginToAzureMobileApps();
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
        print("Completed FB logout via LoginButton")
    }
}

