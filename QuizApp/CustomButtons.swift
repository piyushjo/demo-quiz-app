
import Foundation

class CategoryButtons: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.red.cgColor;
        self.layer.borderWidth = 1.5;
        self.backgroundColor = UIColor.orange;
        self.tintColor = UIColor.white;
    }
}

class AnswerButtons: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
