//
//  AuthenticationViewController.swift
//  My Diary
//
//  Created by Joey on 05/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authentication()
    }
    
    func authentication() {
        
        let authenticationContext = LAContext()
        var error: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to view notes", reply: { (success, error) in
                
                if success {
                    
                    DispatchQueue.main.async {
                        
                        self.dismiss(animated: false, completion: {
                            
                            hasAuthenticated = true
                        })
                    }
                    
                }else {
                    if let error = error as? NSError {
                        
                        let message = self.errorMessageForLaErrorCode(errorCode: error.code)
                        self.showAlert(with: "Error", andMessage: message)
                    }
                }
                
            })
            
        }else {
            
            //No biometrics
            showAlert(with: "Error", andMessage: "This device does not have a Touch ID sensor")
        }
    }
    
    func errorMessageForLaErrorCode(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        return message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
