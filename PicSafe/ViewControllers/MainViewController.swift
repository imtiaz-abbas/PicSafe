//
//  MainViewController.swift
//  PicSafe
//
//  Created by Imtiaz Abbas on 02/09/19.
//  Copyright © 2019 Imtiaz Abbas. All rights reserved.
//

import UIKit
import Stevia
import SQLite3
import TLPhotoPicker
import Photos

class MainViewController: UIViewController {
  var selectedAssets = [TLPHAsset]()
  var  imageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.init(red: 1/26, green: 0, blue: 0, alpha: 1)
    let button = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    self.view.sv(button, button2, imageView)
    // style button
    
    button.Top == self.view.safeAreaLayoutGuide.Top + 20
    button.centerHorizontally()
    button.text("Hide photos")
    
    button2.Top == button.Bottom + 20
    button2.centerHorizontally()
    button2.text("Show hidden photos")
    
    imageView.Top == button2.Bottom + 20
    imageView.Bottom == self.view.Bottom - 20
    imageView.Right == self.view.Right - 20
    imageView.Left == self.view.Left + 20
    
    button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    button2.addTarget(self, action: #selector(showHiddenPhotos), for: .touchUpInside)
  }
  
  @objc func showHiddenPhotos(_ sender: UIButton) {
    navigationController?.pushViewController(PhotoCollectionViewController(), animated: true)
  }
  
  private func onImagesSelected() {
    let assetsToBeDeleted: NSMutableArray! = NSMutableArray()
    CommonStorage.shared.storeNumber(count: selectedAssets.count, forKey: "hiddenAssetsCount")
    var uiImages: [Data] = []
    selectedAssets.forEach { (asset) in
      let phAsset = asset.phAsset
      assetsToBeDeleted.add(phAsset)
      let fullResolutionImage = asset.fullResolutionImage
      if let image = fullResolutionImage?.jpegData(compressionQuality: .greatestFiniteMagnitude) {
        uiImages.append(image)
      }
    }
    // storing all images bulk
    ImageStore.shared.storeImages(imagesToBeStored: uiImages)
    self.deleteAssets(assetsToBeDeleted: assetsToBeDeleted)
  }
  
  private func deleteAssets(assetsToBeDeleted assets: NSMutableArray) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.deleteAssets(assets)
    },
     completionHandler: {(success, error)in
      NSLog("Image Deletion -> %@", (success ? "Success":"Error!"))
      if(success){
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
    if (phAsset.mediaType == .image) {
      return true
    }
    return false
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
