//
//  ImagePickerViewModel.swift
//  AllInOneTravels
//
//  Created by devang bhavsar on 07/12/21.
//


import UIKit
import PhotosUI
class ImagePickerViewModel: NSObject {
    //MARK:- Custom Button
    var selectedImageFromGalary:ImagePass?
    var selectImageFromCamera:ImagePass?
    var selectedMultipleImage:TAallImages?
    var arrImage = [UIImage]()
    var isFromGalary:Bool = false
    var arrImagesData = [Data]()
     func setUpButton(btnSubmit:UIButton) {
             
              btnSubmit.layer.shadowColor = UIColor.black.cgColor
              btnSubmit.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
              btnSubmit.layer.masksToBounds = false
              btnSubmit.layer.shadowRadius = 2.0
              btnSubmit.layer.shadowOpacity = 0.5
              if screenWidth > 400 {
                  btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 6
              }
              else if screenWidth > 370 {
                   btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 9
              }
              else {
                  btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 12
              }
     }
    func setUpradiousOFTakeaPhoto(btnSubmit:UIButton) {
       
        btnSubmit.layer.shadowColor = UIColor.black.cgColor
                    btnSubmit.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
                    btnSubmit.layer.masksToBounds = false
                    btnSubmit.layer.shadowRadius = 2.0
                    btnSubmit.layer.shadowOpacity = 0.5
        if screenWidth > 400 {
                         btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 4
                     }
                     else if screenWidth > 370 {
                          btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 5
                     }
                     else {
                         btnSubmit.layer.cornerRadius = btnSubmit.frame.width / 8
                     }
    }
    
    //MARK:- setGradientColor
//    func setupGradiantView(viewController:UIViewController) {
//        let first = hexStringToUIColor(hex: CustomColor().gradeintTopBackGround).cgColor
//               let second = hexStringToUIColor(hex: CustomColor().gradeintBottomBackGround).cgColor
//               viewController.setUpGradientTopToBottom(view: viewController.view, first: first, second: second)
//    }
    //MARK:- Image Picker
    func openCamera(viewController:UIViewController)
    {
        isFromGalary = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.isModalInPresentation = true
            imagePicker.modalPresentationStyle = .overFullScreen
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Alert().showAlert(message: "You don't have camera", viewController: viewController)
        }
    }
    func openGallery(viewController:UIViewController)
    {
        isFromGalary = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.isModalInPresentation = true
            imagePicker.modalPresentationStyle = .overFullScreen
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
             Alert().showAlert(message: "don't have permission to access gallery.", viewController: viewController)
        }
    }
    func multipleImagePicker(viewController:UIViewController)  {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = PHPickerFilter.images

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        viewController.present(pickerViewController, animated: true, completion: nil)
    }
    
}

extension ImagePickerViewModel:UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPickerViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             if let pickedImage = info[.originalImage] as? UIImage {
                
                if isFromGalary {
                    selectedImageFromGalary!(pickedImage)
                }
                else {
                    selectImageFromCamera!(pickedImage)
                }
             }
             picker.dismiss(animated: true, completion: nil)
         }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
       picker.dismiss(animated: true, completion: nil)
        self.arrImage.removeAll()
       for result in results {
          result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
             if let image = object as? UIImage {
                DispatchQueue.main.async {
                   // Use UIImage
                    self.arrImage.append(image)
                    self.selectedImageFromGalary!(image)
                }
             }
          })
       }
    }
}

