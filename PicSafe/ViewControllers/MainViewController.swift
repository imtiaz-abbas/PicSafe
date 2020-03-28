//
//  MainViewController.swift
//  PicSafe
//
//  Created by imtiaz abbas on 02/09/19.
//  Copyright © 2019 Able. All rights reserved.
//

import UIKit
import Stevia
import SQLite3
import TLPhotoPicker
import Photos

class MainViewController: UIViewController {
  var selectedAssets = [TLPHAsset]()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let button = UIButton(type: .system)
    
    self.view.sv(button)
    // style button
    
    button.Top == 30
    button.centerHorizontally()
    button.text("Hide photos")
    
    button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
  }
  
  func onImagesSelected() {
    var delShotsAsset: NSMutableArray! = NSMutableArray()
    selectedAssets.forEach { (asset) in
      let phAsset = asset.phAsset
      delShotsAsset.add(phAsset)
    }
    PHPhotoLibrary.shared().performChanges({
      //Delete Photo
      PHAssetChangeRequest.deleteAssets(delShotsAsset)
    },
     completionHandler: {(success, error)in
      NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
      if(success){
        // Move to the main thread to execute
        DispatchQueue.main.async {
          print("Trashed")
        }
      } else {
        print("Error: \(error)")
      }
    })
  }
  
  @objc func buttonClicked(_ sender: UIButton) {
    let viewController = TLPhotosPickerViewController()
    viewController.delegate = self
    self.present(viewController, animated: true, completion: nil)
  }
}

extension MainViewController: TLPhotosPickerViewControllerDelegate {
  func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
    self.selectedAssets = withTLPHAssets
    self.onImagesSelected()
    return true
  }
  func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    // if you want to used phasset.
  }
  func photoPickerDidCancel() {
    // cancel
  }
  func dismissComplete() {
    // picker viewcontroller dismiss completion
  }
  func canSelectAsset(phAsset: PHAsset) -> Bool {
    //Custom Rules & Display
    //You can decide in which case the selection of the cell could be forbidden.
    return true
  }
  func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
    // exceed max selection
  }
  func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
    // handle denied albums permissions case
    print("handle denied albums permissions case")
  }
  func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
    // handle denied camera permissions case
    print("handle denied camera permissions case")
  }
}
