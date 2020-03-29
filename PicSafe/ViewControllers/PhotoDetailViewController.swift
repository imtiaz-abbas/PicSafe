//
//  PhotoDetailView.swift
//  PicSafe
//
//  Created by Imtiaz Abbas on 28/03/20.
//  Copyright © 2020 Imtiaz Abbas. All rights reserved.
//

import Foundation
import UIKit
import Stevia

class PhotoDetailViewController: UIViewController {
  
  var uiImage: UIImage?
  func setImage(image: UIImage) {
    self.uiImage = image
  }
  
  let actionsView = UIView()
  let imageView = UIImageView()
  let unhideButton = UIButton(type: .system)
  let deleteButton = UIButton(type: .system)
  
  override func viewDidLoad() {
    if let image = self.uiImage {
      self.view.sv(actionsView, imageView)
      self.setupActionsView()
      self.imageView.Top == self.actionsView.Bottom + 5
      self.imageView.Bottom == self.view.Bottom - 20
      self.imageView.Left == self.view.Left
      self.imageView.Right == self.view.Right
      self.imageView.image = image
      self.view.backgroundColor = .black
      self.imageView.contentMode  = .scaleAspectFit
    }
    let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLogin))
    leftGesture.direction = .right
    self.view.addGestureRecognizer(leftGesture)
  }
  
  @objc func swipeToLogin(sender:UISwipeGestureRecognizer) {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func setupActionsView() {
    
    actionsView.Top == self.view.safeAreaLayoutGuide.Top + 20
    actionsView.height(50)
    actionsView.fillHorizontally()
    actionsView.backgroundColor = .black
    actionsView.sv(unhideButton, deleteButton)
    
    unhideButton.Left == actionsView.Left + 20
    deleteButton.Right == actionsView.Right - 20
    
    unhideButton.text("UNHIDE")
    unhideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    deleteButton.text("DELETE")
    deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    unhideButton.addTarget(self, action: #selector(unhideButtonClickAction), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(deleteButtonClickAction), for: .touchUpInside)
  }
  
  @objc func unhideButtonClickAction() {
    if let image = uiImage {
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
      if let error = error {
          // we got back an error!
          let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
      } else {
//          deleteButtonClickAction()
          let ac = UIAlertController(title: "Saved!", message: "Your photo is now recovered and can be viewed in your photos", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
      }
  }
  
  @objc func deleteButtonClickAction() {
    let images = CommonStorage.shared.retrieveImages(forKey: "bulkHiddenImages")
    var filteredImages: [UIImage] = []
    images?.forEach({ (x) in
      let jpegData = x.jpegData(compressionQuality: .greatestFiniteMagnitude)
      if (jpegData != uiImage?.jpegData(compressionQuality: .greatestFiniteMagnitude)) {
        filteredImages.append(x)
      }
    })
    CommonStorage.shared.storeImages(images: filteredImages, forKey: "bulkHiddenImages", noExisting: true)
    if let navController = self.navigationController {
      navController.popViewController(animated: true)
    }
  }
}
