//
//  ViewController.swift
//  LinkedInIOSHelperSwiftDemo
//
//  Created by AHMET KAZIM GUNAY on 17/11/2017.
//  Copyright © 2017 AHMET KAZIM GUNAY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnLogout: UIButton!
    let linkedin = LinkedInHelper.sharedInstance()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnLogout.isHidden = linkedin?.isValidToken() == false
    }
    
    // MARK: Button Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let linkedin = linkedin else { return }
        
        // If user has already connected via linkedin in and access token is still valid then
        // No need to fetch authorizationCode and then accessToken again!
        
        if linkedin.isValidToken() == true {
            linkedin.customSubPermissions = "\(first_name),\(last_name)"
            
            linkedin.autoFetchUserInfo(success: { [weak self] (userInfo) in
                
                guard let strongSelf = self, let info : [AnyHashable : Any] = userInfo  else { return }
                strongSelf.btnLogout.isHidden = !linkedin.isValidToken();
                
                guard let firstName = info["firstName"], let lastName = info["lastName"] else { return }
                let resultString = "first name : \(firstName)\n last name : \(lastName)"
                strongSelf.showAlert(userInfo: resultString)
                
                }, failUserInfo: { (error) in
                    print(error!)
            })
        }
        else {
            linkedin.cancelButtonText = "Cancel"
            linkedin.showActivityIndicator = true
            
            let permissions : [Int] = [Permissions.BasicProfile.rawValue, Permissions.EmailAddress.rawValue, Permissions.Share.rawValue, Permissions.CompanyAdmin.rawValue]
            
            // FIXME: Add your clientId, secret and redeirectUrl here

            linkedin.requestMeWithSenderViewController(self, clientId: "7889k77xz96q39", clientSecret: "5W5FfEqcP4ig7vFC", redirectUrl: "http://www.hurriyet.com.tr/anasayfa/", permissions: permissions, state: "", successUserInfo: { [weak self] (userInfo) in
                
                guard let strongSelf = self, let info : [AnyHashable : Any] = userInfo  else { return }
                strongSelf.btnLogout.isHidden = !linkedin.isValidToken();
                
                guard let firstName = info["firstName"], let lastName = info["lastName"] else { return }
                let resultString = "first name : \(firstName)\n last name : \(lastName)"
                strongSelf.showAlert(userInfo: resultString)
                
                }, failUserInfoBlock: { (error) in
                    
                    print(error!)
            })
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        linkedin?.logout()
        btnLogout.isHidden = linkedin?.isValidToken() == false
    }
    
    // MARK: Private Helpers
    
    private func showAlert(userInfo: String) {
        
        let alertController = UIAlertController(title: "User Info:", message: userInfo, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

