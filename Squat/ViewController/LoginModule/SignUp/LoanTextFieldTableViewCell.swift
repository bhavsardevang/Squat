//
//  LoanTextFieldTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit

class LoanTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    
    @IBOutlet weak var btnCall: UIButton!
    var selectedIndex:taSelectedIndex?
    var callclicked:taSelectedIndex?
    var selectedText:taSelectedText?
    var textFieldResign:taSelectedIndex?
    var alertMessage:TaSelectedValueSuccess?
    @IBOutlet weak var imgDown: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        txtDescription.setLeftPaddingPoints(10.0)
        lblTitle.textColor = .black
        imgDown.tintColor = .black
        txtDescription.textColor = .black//hexStringToUIColor(hex: "C3714B")
        txtDescription.delegate = self
        self.selectionStyle = .none
    }
    func showCallButton(index:Int)  {
        self.btnCall.isHidden = false
        self.btnCall.tag = index
    }
    func hideCallButton() {
        self.btnCall.isHidden = true
    }
    func hideButtonSelection() {
        self.btnSelection.isHidden = true
        self.imgDown.isHidden = true
    }
    func showButtonSelection(index:Int) {
        self.btnSelection.isHidden = false
        self.imgDown.isHidden = false
        self.btnSelection.tag = index
    }
    @IBAction func btnSelectionClicked(_ sender: UIButton) {
        selectedIndex!(sender.tag)
    }
    
    @IBAction func btnCallClicked(_ sender: UIButton) {
        callclicked!(sender.tag)
    }
    
}
extension LoanTextFieldTableViewCell:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedText!(String(textField.text!),textField.tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedText!(String(textField.text!),textField.tag)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    selectedText!(String(value!),textField.tag)
                    return true
                }
            }
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textField.text!))
        if isNumber {
            if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
                if textField.text!.count > 11 {
                    alertMessage!(kMobileDigitAlert)
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.tableView!.reloadData()
        textFieldResign!(textField.tag)
        return true
    }

}
