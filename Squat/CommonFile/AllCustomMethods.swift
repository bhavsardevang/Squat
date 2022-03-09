//
//  AllCustomMethods.swift
//  AllInOneTravels
//
//  Created by devang bhavsar on 07/12/21.
//

import Foundation
import UIKit
//import CoreData
import Floaty
//MARK:- Custom TextField Method
func setCustomTextField(self:UITextField,placeHolder:String,isBorder:Bool) -> UITextField {
    let newTextField:UITextField = self
    var multiplier:Double = 1.0

    if UIDevice.current.userInterfaceIdiom == .pad {
        multiplier = 10.0
    }
//    let value:CGFloat = CustomFontSize().textfieldFontSize / CGFloat(multiplier)
//    let data = "\(value)".split(separator: ".")
//     let newvalue = Int(data[0])
    let value:CGFloat = self.font!.pointSize + CGFloat(multiplier)
    let data = "\(value)".split(separator: ".")
     let newvalue = Int(data[0])
    newTextField.font = UIFont.systemFont(ofSize: CGFloat(newvalue!))//UIFont(name: CustomFontName().textfieldFontName, size: CGFloat(newvalue!))
    newTextField.textColor = UIColor.white
    newTextField.tintColor = UIColor.white
    if isBorder {
        newTextField.layer.borderColor =  hexStringToUIColor(hex:strTheamColor).cgColor
        newTextField.layer.borderWidth = 1.0
        newTextField.layer.cornerRadius = 10.0//
        newTextField.setLeftPaddingPoints(10.0)
        newTextField.setRightPaddingPoints(10.0)
    }
    newTextField.attributedPlaceholder = NSAttributedString(string: placeHolder,
    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    return newTextField
}

func setCommanHeaderView(width:CGFloat) -> CommanView {
    let headerViewXib:CommanView = CommanView().instanceFromNib()
    headerViewXib.imgRight.isHidden = true
    headerViewXib.frame = CGRect(x: 0, y: 0, width: width, height: (screenHeight * 0.1))
    return headerViewXib
}

func setupIpadItem(floaty:Floaty) {
    if UIDevice.current.userInterfaceIdiom == .pad {
        floaty.size = 76
        floaty.itemSize  = 62
        floaty.itemSpace = 34
    }
}

//MARK:- EmailValidation
func isValidEmail(emailStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: emailStr)
}
//MARK:- Remove Space before and after line
func removeWhiteSpace(strData:String) -> String {
    let trimmed:String = strData.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed//trimmed.lowercased()
}
//MARK:- Convert HexColor To UIColor
//func hexStringToUIColor(hex:String) -> UIColor {
//    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//    if (cString.hasPrefix("#")) {
//        cString.remove(at: cString.startIndex)
//    }
//
//    if ((cString.count) != 6) {
//        return UIColor.gray
//    }
//
//    var rgbValue:UInt64 = 0
//    Scanner(string: cString).scanHexInt64(&rgbValue)
//
//    return UIColor(
//        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//        alpha: CGFloat(1.0)
//    )
//}
//MARK:- Save Images Locally
func saveImage(image: UIImage) -> (Bool,Data) {
    let emptyData = Data()
       guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
           return (false,emptyData)
       }
       guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
           return (false,data)
       }
       do {
           try data.write(to: directory.appendingPathComponent("abc.png")!)
           return (true,data)
       } catch {
           return (false,data)
       }
   }
func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}
func convertInAttributedString(strData:String,color:UIColor) -> NSAttributedString {
    // Custom color
  //  let greenColor = UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 1)
    // create the attributed colour
    let attributedStringColor = [NSAttributedString.Key.foregroundColor : color]
    // create the attributed string
    let attributedString = NSAttributedString(string: strData, attributes: attributedStringColor)
    // Set the label
    return attributedString
}
func convertdateFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    //let date = formatter.date(from: date)
    formatter.dateFormat = "MM/dd/yyyy hh:mm a"
    return formatter.string(from: date)
}
func converttimeFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    //let date = formatter.date(from: date)
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}
func convertMonthAndYearFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    //let date = formatter.date(from: date)
    formatter.dateFormat = "MM/yyyy"
    return formatter.string(from: date)
}
func converFunction(date:Date) -> String? {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    formatter.dateFormat = "yyyy,EEEE, MMM d" //@"MMM dd, yyyy";
    let timeZone = NSTimeZone()
    formatter.timeZone = timeZone as TimeZone
    var strSelectedDate:String = ""
    strSelectedDate = formatter.string(from: date)
    strSelectedDate = strSelectedDate + ("th")
    return strSelectedDate
}

func convertFunctionWithMonths(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    formatter.dateFormat = "yyyy,MMM" //@"MMM dd, yyyy";
    let timeZone = NSTimeZone()
    formatter.timeZone = timeZone as TimeZone
    var strSelectedDate:String = ""
    strSelectedDate = formatter.string(from: date)
    return strSelectedDate
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

struct Alert {
    func showAlert(message:String,viewController:UIViewController) {
        let alert = UIAlertController(title:kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

func setAlertWithCustomAction(viewController:UIViewController,message:String,ok okBlock: @escaping ((Bool) -> Void),isCancel:Bool,cancel cancelBlock: @escaping ((Bool) -> Void)) {
    let alertController = UIAlertController(title: kAppName, message:message, preferredStyle: .alert)
    // Create the actions
    let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
        UIAlertAction in
        okBlock(true)
    }
    alertController.addAction(okAction)
    if isCancel {
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            cancelBlock(true)
        }
        alertController.addAction(cancelAction)
    }
    viewController.present(alertController, animated: true, completion: nil)
}

func validatePhoneNumber(value: String) -> Bool {
    let PHONE_REGEX = "^[0-9]{10}$" //((\\+)|(00))
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func checkForNextDate(selectedDate:Date) -> Int  {
    let dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    let date = Date()
    let newDate = dateFormatter.string(from: date)
    let curentDate:Date = dateFormatter.date(from: newDate)!
    if selectedDate != nil {
        let newDate = dateFormatter.string(from: selectedDate )
        let convertSavedDate:Date = dateFormatter.date(from: newDate)!
        let diffInDays:Int = Calendar.current.dateComponents([.day], from: convertSavedDate, to:curentDate).day!
        return diffInDays
    }
    return 0
}
func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

    let path = CGMutablePath()
    path.addLines(between: [p0, p1])
    shapeLayer.path = path
    view.layer.addSublayer(shapeLayer)
}
//func setUpBackgroundImage(imageName:String) -> UIImageView {
//   // headerViewXib.frame =
//    let imageView = UIImageView()
//    imageView.frame = CGRect(x: 0, y: (screenHeight * 0.1), width: screenWidth, height: screenHeight - (screenHeight * 0.1))
//    imageView.image = UIImage(named:imageName)
//    imageView.contentMode = UIView.ContentMode.scaleToFill
//    return imageView
//}
func getCurrentTimeAndDate() -> (Int,Int) {
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(. hour, from: date)
    let minutes = calendar.component(. minute, from: date)
    return(hour,minutes)
}

func convertDateWithTime(date:String,hour:Int,minutes:Int) -> Date  {
    var dateComponents = DateComponents()
    let arrdevidedString:[String] = date.components(separatedBy: "/")
    dateComponents.year = Int(arrdevidedString[2])
    dateComponents.month = Int(arrdevidedString[1])
    dateComponents.day = Int(arrdevidedString[0])
    dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
    var hours:Int = hour
    var minute:Int = minutes
    if hour == nil || hour == 0 {
     let dateAndTime = getCurrentTimeAndDate()
        hours = dateAndTime.0
        minute = dateAndTime.1
    }
    dateComponents.hour = hours
    dateComponents.minute = minute
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime!
}

//func moveToMainViewController(viewController:UIViewController) {
//    let objMainViewController:MainViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "MainViewController") as! MainViewController
//    objMainViewController.strTypeSelected = SignUpDisplayTitle.mainViewController.strSelectedTitle()
//    viewController.revealViewController()?.pushFrontViewController(objMainViewController, animated: true)
//}

//func moveToSettingViewController(viewController:UIViewController) {
//    let objSettingViewController:SettingViewController = UIStoryboard(name: CalenderStoryBoard, bundle: nil).instantiateViewController(identifier: "SettingViewController") as! SettingViewController
//    viewController.revealViewController()?.pushFrontViewController(objSettingViewController, animated: true)
//}
func logOutAlertMessage(viewController:UIViewController) {
    let alert = UIAlertController(title: kAppName, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (logout) in
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        viewController.view.window?.rootViewController = initialViewController
    }))
    viewController.present(alert, animated: true, completion: nil)
}

