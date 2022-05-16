//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Hüseyin Kaya on 15.05.2022.
//

import UIKit
import Firebase //Unutma

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription) //?? "Error" 'a gerek yok
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
    
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in  //Auth objesi oluşturuldu ve kullanıcıdan bilgileri alıyoruz
                
                if error != nil { //hata mesajı varsa
                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription) //firebase'in hata mesajını gösterir 6haneli şifre ister vb
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                
                
            }
        } else {
           makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }

        
       
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
    
    
}

