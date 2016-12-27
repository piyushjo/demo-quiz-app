//
//  Created by Piyush Joshi on 12/27/16.
//  Copyright © 2016 Piyush Joshi. All rights reserved.
//

import Foundation

class CategoryButtons: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.red.cgColor;
        self.layer.borderWidth = 1.5;
        self.backgroundColor = UIColor.blue;
        self.tintColor = UIColor.white;
    }
}

class AnswerButtons: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.brown.cgColor;
        self.layer.borderWidth = 1.5;
        self.backgroundColor = UIColor.lightGray;
        self.tintColor = UIColor.white;
    }
}
