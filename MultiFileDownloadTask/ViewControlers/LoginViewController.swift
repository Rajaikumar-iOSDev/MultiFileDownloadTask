//
//  LoginViewController.swift
//  MultiFileDownloadTask
//
//  Created by Subburaman, Rajai Kumar on 14/08/19.
//  Copyright © 2019 Subburaman, Rajai Kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK:- IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var captchaTextField: UITextField!
    @IBOutlet weak var captchaLabel: UILabel!
    // MARK:- Properties
    var originalsizes: CGRect!
    var modifiedsizes: CGRect!
    var isYChanged = false
    
    // MARK:- ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCaptcha()
    
        setTapGestute()
        originalsizes = CGRect(
            origin: CGPoint(x: self.view.frame.origin.x, y: view.frame.origin.y),
            size: view.frame.size
        )
        modifiedsizes = CGRect(
            origin: CGPoint(x: self.view.frame.origin.x, y: view.frame.origin.y - 100),
            size: view.frame.size
        )
        // Do any additional setup after loading the view.
    }


}
// MARK:- Support Methods
extension LoginViewController{
    
    fileprivate func setTapGestute() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = self.originalsizes
            self.view.endEditing(true)
            self.isYChanged = false})
    }
    
    fileprivate func setCaptcha() {
        let randomNumber = Int.random(in: 100000 ... 999999)
        
        captchaLabel.text = String(describing: randomNumber)
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        if nameTextField.text?.count != 0 && captchaTextField.text?.count != 0 {
            
            if captchaTextField.text! == captchaLabel.text!{
                
                UserDefaults.standard.set(nameTextField.text!, forKey: "name")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let GetURLVC = storyBoard.instantiateViewController(withIdentifier: "GetURLViewController") as! GetURLViewController
                self.present(GetURLVC, animated: true, completion: nil)
                
                
                
            }
            
        }
        
    }
    

    
}
// MARK:- UITextFieldDelegate
extension LoginViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = self.originalsizes
            self.view.endEditing(true)
            self.isYChanged = false})
        return false
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if isYChanged == false{
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame = self.modifiedsizes
                
                self.isYChanged = true
                
            })
            
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
}
