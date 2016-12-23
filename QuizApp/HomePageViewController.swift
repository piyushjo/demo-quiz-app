//
//  ViewController.swift
//  QuizApp
//
//  Created by Piyush Joshi on 12/19/16.
//  Copyright © 2016 Piyush Joshi. All rights reserved.
//

import UIKit
import WebKit

import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class ViewController: UIViewController {
    
    var azureMobileClient = MSClient(applicationURLString: "https://mobile-c009a447-0dc0-4178-8bd0-85b746833bd6.azurewebsites.net/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FB Login
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ]);
        loginButton.center = view.center;
        loginButton.delegate = self;
        view.addSubview(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Did complete login via LoginButton with result \(result)");
        let payload: [String: String] = ["access_token": (AccessToken.current?.authenticationToken)!];
        
        azureMobileClient.login(withProvider: "facebook", token: payload) { (user, error) in

            if ((error) != nil) {
                print("1Error logging in: %@" + error.debugDescription);
            } else {
                print("1Logged in as user" + (user?.userId)!);
        
                let table = self.azureMobileClient.table(withName: "LastPlayedScore");
                
                //let newItem = ["score": 200];
                //table.insert(newItem) { (result1, error1) in
                //    if let err = error1 {
                //        print("ERROR ", err);
                //    } else if let item = result1 {
                //        print("Score: ", item["score"]!);
                //    }
                //}
                
                table.read { (result2, error2) in
                    if let err = error2 {
                        print("ERROR ", err)
                    } else if let items = result2?.items {
                        for item in items {
                            print("Todo Item: ", item["score"]!)
                        }
                    }
                }
            
            }
        };
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did logout via LoginButton")
    }
}

