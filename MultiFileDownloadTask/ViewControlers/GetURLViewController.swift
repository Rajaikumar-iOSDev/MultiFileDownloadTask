//
//  GetURLViewController.swift
//  MultiFileDownloadTask
//
//  Created by Subburaman, Rajai Kumar on 13/08/19.
//  Copyright © 2019 Subburaman, Rajai Kumar. All rights reserved.
//

import UIKit
import MZDownloadManager
class GetURLViewController: UIViewController {
    // MARK:- IBOutlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var urlOneTextField: UITextField!
    @IBOutlet weak var urlTwoTextField: UITextField!
    // MARK:- Properties
    var originalsizes: CGRect!
    var modifiedsizes: CGRect!
    var isYChanged = false
    let myDownloadPath = MZUtility.baseFilePath + "/Downloads"

    
    // MARK:- ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        setUsername()
        
        originalsizes = CGRect(
            origin: CGPoint(x: self.view.frame.origin.x, y: view.frame.origin.y),
            size: view.frame.size
        )
        modifiedsizes = CGRect(
            origin: CGPoint(x: self.view.frame.origin.x, y: view.frame.origin.y - 60),
            size: view.frame.size
        )
        // Do any additional setup after loading the view.
    }


    
    


}
// MARK:- Support Methods
extension GetURLViewController{
fileprivate func setTapGestute() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tap)
}

fileprivate func setUsername() {
    let name = UserDefaults.standard.string(forKey: "name") ?? ""
    userNameLabel.text=name
}


@objc func dismissKeyboard() {
     UIView.animate(withDuration: 0.5, animations: {
    self.view.frame = self.originalsizes
    self.view.endEditing(true)
        self.isYChanged = false})
}
@IBAction func downLoadAction(_ sender: Any) {
     if urlOneTextField.text?.count != 0 && urlTwoTextField.text?.count != 0 {
    let urlArray = [urlOneTextField.text!,urlTwoTextField.text!]
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    let multiFileDownloader = storyBoard.instantiateViewController(withIdentifier: "MultiFileDownloadViewController") as! MultiFileDownloadViewController
        multiFileDownloader.urlArray = urlArray
   
        self.present(multiFileDownloader, animated: true, completion: nil)}
    
}}
// MARK: - UITextFieldDelegate
extension GetURLViewController:UITextFieldDelegate{
    
    
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

