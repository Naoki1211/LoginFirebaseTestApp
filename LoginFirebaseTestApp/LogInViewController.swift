//
//  LogInViewController.swift
//  LoginFirebaseTestApp
//
//  Created by Naoki on 2021/04/17.
//

import UIKit
import Firebase
import PKHUD

struct User{
    var name:String
    var email:String
    var time: Timestamp
    
    init(dict:[String:Any]){
        self.name = dict["name"] as! String
        self.email = dict["email"] as! String
        self.time =  dict["createdAt"] as! Timestamp
    }
}

var recentData:User!

class LogInViewController: UIViewController {
    var signUpView:UILabel?
    lazy var emailField:UITextField = emailText()
    var userField:UITextField?
    
    lazy var passwardField =  {
        () -> UITextField in
        let passward = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 3, height: 50))
        passward.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.width / 3 + self.view.bounds.width / 4 + self.view.bounds.width / 5)
        passward.placeholder = "パスワード"
        passward.borderStyle = UITextField.BorderStyle.roundedRect
        passward.layer.cornerRadius = 17
        passward.font = UIFont.systemFont(ofSize: 16)
        passward.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
        passward.layer.masksToBounds = false
        passward.layer.cornerRadius = 10
        passward.layer.shadowOpacity = 0.2
        
        return passward
    }()
    
    var registerButton:UIButton?
    var alreadyView:(UILabel,UIButton)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        signUpView = signView()
        self.view.addSubview(emailField)
        self.view.addSubview(passwardField)
        userField = userText()
        registerButton = reButton()
        registerButton?.isEnabled = false
        alreadyView = alreadyLabel()
        
        emailField.delegate = self
        userField?.delegate = self
        passwardField.delegate = self
    }
    
    
    func signView() -> UILabel{
        let signLabel = UILabel()
        signLabel.text = "Sign Up"
        signLabel.textColor = .black
        signLabel.font = UIFont.systemFont(ofSize: 50)
        signLabel.sizeToFit()
        signLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.width / 3)
        self.view.addSubview(signLabel)
        
        return signLabel
    }
    
    func emailText() -> UITextField{
        let email = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 3, height: 50))
        email.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.width / 3 + self.view.bounds.width / 4)
        email.placeholder = "メールアドレス"
        email.borderStyle = UITextField.BorderStyle.roundedRect
        email.layer.cornerRadius = 10
        email.font = UIFont.systemFont(ofSize: 16)
        email.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
        email.layer.masksToBounds = false
        email.layer.cornerRadius = 10
        email.layer.shadowOpacity = 0.2
        
        return email
        
    }
    
    func userText() -> UITextField{
        let yLength:CGFloat = self.view.bounds.width / 3 + self.view.bounds.width / 4 + self.view.bounds.width / 5
        let user = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 3, height: 50))
        user.center = CGPoint(x: self.view.bounds.width / 2, y: yLength + self.view.bounds.width / 5 )
        user.placeholder = "ユーザー名"
        user.borderStyle = UITextField.BorderStyle.roundedRect
        user.layer.cornerRadius = 10
        user.font = UIFont.systemFont(ofSize: 16)
        user.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
        user.layer.masksToBounds = false
        user.layer.cornerRadius = 10
        user.layer.shadowOpacity = 0.2
        self.view.addSubview(user)
        
        return user
        
    }

    func reButton() -> UIButton{
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 4, height: 45))
        button.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 7 * 4)
        button.backgroundColor = UIColor(red: 1, green: 0.6, blue:0, alpha: 0.6)
        button.setTitle("登録", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.6), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(registButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(button)

        return button
    }
    func alreadyLabel() -> (UILabel,UIButton){
        let alreadyLabel = UILabel()
        alreadyLabel.text = "既にアカウントをお持ちの方は"
        alreadyLabel.textColor = .black
        alreadyLabel.font = UIFont.systemFont(ofSize: 17)
        alreadyLabel.sizeToFit()
        alreadyLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 8 * 5)
        self.view.addSubview(alreadyLabel)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 4, height: 45))
        button.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 8 * 5 + 17)
        button.setTitle("こちら", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(button)
        
        return (alreadyLabel,button)
    }
    
    
    @objc func registButtonAction(_ sender:UIButton){
        handleFirebase()
    }
    
    //Authenticationni情報を保存する
    func handleFirebase() {
        HUD.show(.progress, onView: self.view)
        
        guard let email = emailField.text else {
            return
        }
        
        guard let passward = passwardField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: passward, completion: {
            (res:AuthDataResult?,err:Error?) -> Void in
            if let err = err{
                print("認証情報の保存に失敗しました。\(err)")
                
                HUD.hide({
                    (_) -> Void in
                    HUD.flash(.error, delay: 1)
                })
                
            }else{
                print("認証情報に成功しました。")
                
            }
            self.addFireStore(email2: email)
        })
    }
    //firestoreの情報を保存する
    func addFireStore(email2:String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let name = userField?.text else {
            return
        }
        
        let docData:[String:Any] = ["email":email2,"name":name,"createdAt":Timestamp()]
        Firestore.firestore().collection("users").document(uid).setData(docData,completion: {
            (err:Error?) -> Void in
            if let err = err{
                 print("Firestoreに保存失敗。\(err)")
                
                HUD.hide({
                    (_) -> Void in
                    HUD.flash(.error, delay: 1)
                })
                
            }else {
                print("Firestoreに保存成功しました。")
            }
            
            self.getFireStore(uid2: uid)
        })
    }
    
    //firestoreに保存した情報を取得する
    func getFireStore(uid2:String){
        Firestore.firestore().collection("users").document(uid2).getDocument(completion: {
            (snapshot, err) in
            if let err = err{
                print("ユーザー情報の取得に失敗しました。\(err)")
                HUD.hide({
                    (_) -> Void in
                    HUD.flash(.error, delay: 1)
                })
                
            }else{
                guard let data = snapshot?.data() else{
                    return
                }
                let newDate = User(dict: data)
                recentData = newDate
                print("ユーザー情報の取得ができました")
              
                HUD.hide({
                    (_) -> Void in
                    HUD.flash(.success, onView: self.view, delay: 1, completion: {
                        (_) -> Void in
                        
                        let next = HomeViewController()
                        next.modalPresentationStyle = .fullScreen
                        //next.modalTransitionStyle = .crossDissolve
                        self.present(next, animated: true, completion: nil)
                    })
                })
                
            }
        })
    }
    
}

extension LogInViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField){
        guard let emailIsEmpty = emailField.text?.isEmpty else {return}
        guard let nameIsEmpty = userField?.text?.isEmpty else {return}
        guard let passwardIsEmpty =  passwardField.text?.isEmpty else {return}
        
        let emailIsEmpty2 = emailIsEmpty ? true : false
        let nameIsEmpty2 = nameIsEmpty ? true : false
        let passwardIsEmpty2 = passwardIsEmpty ? true : false
        
        if emailIsEmpty2 || nameIsEmpty2 || passwardIsEmpty2{
            registerButton?.isEnabled = false
            registerButton?.backgroundColor = UIColor(red: 1, green: 0.6, blue:0, alpha: 0.6)
            registerButton?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.6), for: .normal)
        }else {
            registerButton?.isEnabled = true
            registerButton?.backgroundColor = UIColor(red: 1, green: 0.6, blue:0, alpha: 1)
            registerButton?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
}
