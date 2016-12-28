//
//  Created by Piyush Joshi on 12/19/16.
//  Copyright © 2016 Piyush Joshi. All rights reserved.
//

import UIKit
import WebKit

import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // FB Login
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ]);
        loginButton.center = view.center;
        loginButton.delegate = self;
        view.addSubview(loginButton);
        
        // If there is already an FB access token, let the player play the game
        if (AccessToken.current != nil) {
            self.playButton.isEnabled = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        print("Completed FB login via LoginButton with result: \(result)");
        
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
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Completed FB logout via LoginButton")
    }
}

