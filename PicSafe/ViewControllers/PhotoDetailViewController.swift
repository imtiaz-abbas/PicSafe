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
  
  var uiImage: Data?
  func setImage(image: Data) {
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
      self.imageView.image = UIImage(data: image)
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
    if let uiImageData = uiImage {
      if let image = UIImage(data: uiImageData) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
      }
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      // we got back an error!
      let ac = UIAlertController(title: "Unable to restore your photo. Please contact support.", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      //          deleteButtonClickAction()
      let ac = UIAlertController(title: "Saved!", message: "Your photo is now recovered and can be viewed in your photos", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      
      if let uiImageData = uiImage {
        ImageStore.shared.removeImage(uiImage: uiImageData)
        if let navController = self.navigationController {
          navController.popViewController(animated: true)
        }
      }
      present(ac, animated: true)
    }
  }
  
  @objc func deleteButtonClickAction() {
    if let uiImageData = uiImage {
      ImageStore.shared.removeImage(uiImage: uiImageData)
    }
    if let navController = self.navigationController {
      navController.popViewController(animated: true)
    }
  }
}
