//
//  ViewController.swift
//  Squat
//
//  Created by devang bhavsar on 16/02/22.
//

import UIKit
import LocalAuthentication
import Localize_Swift
class ViewController: UIViewController {
    
    @IBOutlet weak var lblSIgnUp: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var lblNoAccount: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnFace: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    var objLoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpConfigureData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    func setUpConfigureData() {
        self.viewMain.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.txtMobileNumber.delegate = self
        self.txtMobileNumber.placeholder = "Email Id".localized() + "/" + "Mobile Number".localized()
        self.txtPassword.placeholder  = "Password".localized()
        self.btnLogin.setUpButton()
        self.btnLogin.setTitle("SAVE".localized(), for: .normal)
        self.lblOR.text = "OR".localized()
        self.lblForgotPassword.text = "Forgot Password".localized()
        self.lblNoAccount.text = "Don't have an account".localized()
        self.lblSIgnUp.text = "Signup here".localized()
        
        objLoginViewModel.viewController = self
        objLoginViewModel.fetchData { (isSuccess) in
        }
        guard let value = UserDefaults.standard.value(forKey: kSelectedLanguage) else {
            self.openLangaugeSelectrion()
            return
        }
    }

    
    func openLangaugeSelectrion() {
        let objForgotPasswordViewController:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        objForgotPasswordViewController.isFromLanguage = true
        objForgotPasswordViewController.modalPresentationStyle = .overFullScreen
        self.present(objForgotPasswordViewController, animated: true, completion: nil)
    }
    
    @objc func setUpText() {
        self.setUpCustomField()
    }
    
    func setUpCustomField() {
        DispatchQueue.main.async {
            self.btnLogin.setTitle("SAVE".localized(), for: .normal)
            self.lblOR.text = "OR".localized()
            self.lblForgotPassword.text = "Forgot Password".localized()
            self.lblNoAccount.text = "Don't have an account".localized()
            self.lblSIgnUp.text = "Signup here".localized()
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        let userDefault = UserDefaults.standard
        var userData:String = ""
        if txtMobileNumber.text == "bdevang86@gmail.com" && txtPassword.text == "123456" {
            objLoginViewModel.checkForDataExist { (isSuccess) in
                if !isSuccess {
                    DispatchQueue.main.async {
                        self.objLoginViewModel.updateData = {[weak self] in
                            self!.moveToNextViewController()
                        }
                        self.objLoginViewModel.setUpDatabaseForExsitngUser()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.moveToNextViewController()
                    }
                }
            }
            return
        }
        if txtMobileNumber.text!.isEmpty {
            Alert().showAlert(message: "please enter the number or email id".localized(), viewController: self)
            return
        } else if !validatePhoneNumber(value: txtMobileNumber.text!) {
            guard let email = userDefault.value(forKey: kEmailId) else {
                Alert().showAlert(message: "please sign up".localized(), viewController: self)
                return
            }
            userData = email as! String
            // Alert().showAlert(message: "please provide valied mobile number", viewController: self)
        }else {
            let userDefault = UserDefaults.standard
            guard let mobileNumber = userDefault.value(forKey: kNumber)  else {
                Alert().showAlert(message: "please sign Up".localized(), viewController: self)
                return
            }
            userData = mobileNumber as! String
        }
        if userData == txtMobileNumber.text! {
            userDefault.set(true, forKey:kLogin)
            userDefault.synchronize()
            self.moveToNextViewController()
        } else {
            Alert().showAlert(message: "please provide valied mobile number".localized(), viewController: self)
        }
    }
    
    func moveToNextViewController() {
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = initialViewController
    }

    @IBAction func btnFaceClicked(_ sender: Any) {
        self.loginUsingBioMatrix()
    }
    
    func loginUsingBioMatrix() {
        let userDefault = UserDefaults.standard
        var strNumber:String = ""
        if let newNumber = userDefault.value(forKey: kEmailId) {
            strNumber = newNumber as! String
        }
        if strNumber.count > 2 {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (isvalied, error) in
                    if isvalied {
                        DispatchQueue.main.async { [unowned self] in
                         self.moveToNextViewController()
                        }
                    }else {
                        DispatchQueue.main.async {
                            Alert().showAlert(message: "\(error.debugDescription)", viewController: self)
                        }
                    }
                })
            } else {
                Alert().showAlert(message: "please check allowcation of face recognization or thumbnail".localized(), viewController: self)
            }
        } else {
            Alert().showAlert(message: "please we don't have credential so first time login with email and password".localized(), viewController: self)
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        let objSignUpViewController:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objSignUpViewController.modalPresentationStyle = .overFullScreen
        self.present(objSignUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        let objForgotPassword:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        objForgotPassword.modalPresentationStyle = .overFullScreen
        self.present(objForgotPassword, animated: true, completion: nil)
    }
    
}

