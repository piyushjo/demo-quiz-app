//
//  Created by Piyush Joshi on 12/24/16.
//  Copyright © 2016 Piyush Joshi. All rights reserved.
//

import UIKit
import os.log

class Question1ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Actions events
    @IBAction func incorrectAnswerProvided(_ sender: UIButton) {
        resultLabel.text = "INCORRECT";
        disableAllButtons();
    }
    
    @IBAction func correctAnswerProvided(_ sender: UIButton) {
        resultLabel.text = "CORRECT";
        disableAllButtons();
    }
    
    func disableAllButtons() {
        answer1Button.isEnabled = false;
        answer2Button.isEnabled = false;
        answer3Button.isEnabled = false;
    }
}
