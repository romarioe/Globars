//
//  AuthViewController.swift
//  Globars
//
//  Created by Roman Efimov on 30.09.2020.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    
    
    func setupUI(){
        usernameTextFiled.text = ""
        passwordTextField.text = ""
        signButton.layer.cornerRadius = 10
        passwordTextField.isSecureTextEntry = true
    }
    
     
    
    func getToken(username: String, password: String){
        
        NetworkManager.shared.auth(username: username, password: password) { (token, success) in
            guard let token = token, let success = success else {return}
            self.token = token
            self.checkSuccessStatus(success: success)
        }
        
    }
    
    
    
    func checkSuccessStatus(success: Bool){
        if success {
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "ShowMap", sender: self)
            }
        } else
        {
            DispatchQueue.main.async{
                self.showAlert(message: "Неверный логин или пароль. \nПопробуйте ещё раз.")
            }
        }
    }
    
      
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func signIn(){
        guard let username = usernameTextFiled.text, let password = passwordTextField.text else {return}

        if username != "" && password != "" {
            getToken(username: username, password: password)
        }
        else {
            showAlert(message: "Введите логин и пароль")
        }
    }
    
    
    
    
    @IBAction func signButtonClick(_ sender: Any) {
        signIn()
    }
    
    
    
    
    @IBAction func usernameTextFieldReturnButtonClick(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    
    
    
    @IBAction func passwordTextFieldReturnButtonClick(_ sender: Any) {
        signIn()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MapViewController
        destinationVC.token = token
    }
    
}




