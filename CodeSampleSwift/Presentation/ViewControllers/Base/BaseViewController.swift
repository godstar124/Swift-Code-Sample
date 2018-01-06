//
//  BaseViewController.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurateKeyboardNotifications()
    }
    
    func animateLayout() {
        UIView.animate(withDuration: AnimationConstants.animationSpeed) { 
            self.view.layoutIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    func configurateKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

//MARK: keyboard notifications
//Use for getting the location and size of the keyboard and changing window content
extension BaseViewController {
    func keyboardWillShow(notification: Notification) {
        let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rawFrame = value.cgRectValue
        let keyboardFrame = view.convert(rawFrame, from: nil)
        let keyboardheight = keyboardFrame.size.height
        bottomConstraint?.constant = keyboardheight
        UIView.animate(withDuration: AnimationConstants.animationSpeed) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0.0
        UIView.animate(withDuration: AnimationConstants.animationSpeed) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

//MARK: auto switch textFields
//Selecting next input field by return key
extension BaseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            findNextTextField(after: textField.tag)
            return false
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func findNextTextField(after tag: Int) {
        let allTextFields = searchAllTextFields(inView: view)
        for textField in allTextFields {
            if textField.tag == tag + 1 {
                textField.becomeFirstResponder()
                break
            }
        }
    }
    
    func searchAllTextFields(inView: UIView) -> [UITextField] {
        var allTextFields = [UITextField]()
        for subview in inView.subviews {
            if let textfield = subview as? UITextField {
                allTextFields.append(textfield)
            } else  {
                let arr = searchAllTextFields(inView: subview)
                allTextFields.append(contentsOf: arr)
            }
        }
        return allTextFields
    }
}
