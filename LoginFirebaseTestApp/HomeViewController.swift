//
//  HomeViewController.swift
//  LoginFirebaseTestApp
//
//  Created by Naoki on 2021/04/19.
//

import UIKit
import Foundation
import Firebase

class HomeViewController:UIViewController{
    
    var titleView:UILabel?
    var nameView:UILabel?
    var emailView:UILabel?
    var timeView:UILabel?
    var logOutButton:UIButton?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        titleView = titlelabel()
        nameView = nameLabel()
        emailView = emailLabel()
        timeView = timeLabel()
        logOutButton = logOut()
        
        
    }
    
    func titlelabel() -> UILabel{
        let titleLabel = UILabel()
        titleLabel.text = "Welcome"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 50)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 7 * 3)
        self.view.addSubview(titleLabel)
        
        return titleLabel
    }
    
    func nameLabel() -> UILabel{
        let nameLabel = UILabel()
        nameLabel.text = recentData.name + "さんようこそ"
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.view.addSubview(nameLabel)
        
        return nameLabel
    }
    
    func emailLabel() -> UILabel{
        let emailLabel = UILabel()
        emailLabel.text = recentData.email
        emailLabel.textColor = .black
        emailLabel.font = UIFont.systemFont(ofSize: 17)
        emailLabel.sizeToFit()
        emailLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + self.view.bounds.width / 6)
        self.view.addSubview(emailLabel)
        
        return emailLabel
    }
    
    func timeLabel() -> UILabel{
        let dataString = dataFormatterForCreatedAt(date: recentData.time.dateValue())
        let timeLabel = UILabel()
        timeLabel.text = "作成日: " + dataString
        timeLabel.textColor = .black
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        timeLabel.sizeToFit()
        timeLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + self.view.bounds.width / 6 * 2)
        self.view.addSubview(timeLabel)
        
        return timeLabel
    }
    
    func logOut() -> UIButton{
        let logOutButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height / 5, height: 40))
        logOutButton.center = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height / 2 + self.view.bounds.width / 6 * 3 )
        logOutButton.backgroundColor = .orange
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        logOutButton.layer.cornerRadius = 20
        logOutButton.addTarget(self, action: #selector(logOutButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(logOutButton)

        return logOutButton
    }
    
    @objc func logOutButtonAction(_ sender:UIButton){
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }catch (let err){
            print("ログアウトに失敗しました。\(err)")
        }
    }
    
    func dataFormatterForCreatedAt(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ja_JP")
        
        return formatter.string(from: date)
    }
}
