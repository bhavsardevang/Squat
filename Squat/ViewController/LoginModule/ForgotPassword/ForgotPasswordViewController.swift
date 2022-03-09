//
//  ForgotPasswordViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 17/03/21.
//

import UIKit
import MessageUI
import Localize_Swift

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var lblSepratorMobile: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblSepratorEmail: UILabel!
    @IBOutlet weak var viewData: UIView!
    var objForgotPassword = ForgotPasswordViewModel()
    var objLangaugeViewModel = LangaugeListViewModel()
    @IBOutlet weak var tblDisplayData: UITableView!
    var isFromLanguage:Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   // var objUserProfileDatabaseQuerySetUp = UserProfileDatabaseQuerySetUp()
    var arrSelectedData = [String:Any]()
    var strHeader:String = "Forgot Password".localized()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isFromLanguage {
            objLangaugeViewModel.setUpCustomDelegate()
            objLangaugeViewModel.setUpLanguageSelection()
            objLangaugeViewModel.tblDisplay = self.tblDisplayData
            self.tblDisplayData.delegate = self
            self.tblDisplayData.dataSource = self
            strHeader = "Prefer Language".localized()
            viewData.isHidden = true
        } else {
            self.configData()
            viewData.isHidden = false
        }
        objForgotPassword.setHeaderView(headerView: viewHeader, title: strHeader)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
        self.txtEmail.placeholder = "Email Id".localized()
        self.txtMobileNumber.placeholder = "Mobile Number".localized()
        btnSubmit.setUpButton()
        btnSubmit.setTitle("SUBMIT".localized(), for: .normal)
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if isFromLanguage {
           let validate = objLangaugeViewModel.validationData()
            if validate {
                objLangaugeViewModel.setUpSelectedLanguage(strLanguage: objLangaugeViewModel.strSelectedCode)
                self.dismiss(animated: true, completion: nil)
            } else {
                Alert().showAlert(message: "please select preferable langauge".localized(), viewController: self)
            }
           
        } else {
            let valiedDate = validation()
            if valiedDate {
                let valiedNumber = getDataFromDB(number: txtMobileNumber.text!)
                let userDefault = UserDefaults.standard
                if userDefault.value(forKey: kPassword) != nil && valiedNumber {
                    let password = userDefault.value(forKey: kPassword)
                    self.setupForgotPasswordData(password: password as! String)
                } else {
                    guard let email = userDefault.value(forKey: kEmailId) else {
                        Alert().showAlert(message: "Email or Mobile number does not match".localized(), viewController: self)
                        return
                    }
                    if email as! String == txtEmail.text! && valiedNumber {
                        let password = userDefault.value(forKey: kPassword)
                        self.setupForgotPasswordData(password: password as! String)
                    }
                }
            }
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ForgotPasswordViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objLangaugeViewModel.arrLanguage.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objLangaugeViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "BusinessListTableViewCell") as! BusinessListTableViewCell
        objLangaugeViewModel.setUpCellData(cell: cell, index: indexPath.row)
        return cell
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objLangaugeViewModel.setupDataSelection(index: indexPath.row)
    }
}
