//
//  SignUpViewController.swift
//  FreshLoginProject
//
//  Created by Pavithra Moranganti on 4/17/22.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        errorLabel.alpha=0
        
    }
    func validateFields()->String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make sure your password is at least 8 characters long, contains a special character and a number."
        }
        return nil
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().createUser(withEmail: email, password: password) {(result,err) in
                if error != nil {
                    self.showError("Error creating user")
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    
                    
                    self.transitionToHome()
                    
                    
                    
                }
            }
                    
                    
                    
                }
            }
        
    
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha=1
    }
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
    

