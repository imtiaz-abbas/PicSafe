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

class PhotosAlbumView: UIView {
  let photosText = UITextField()
  let thumbnailView = UIImageView()
  
  convenience init() {
    self.init(frame: CGRect.zero)
    self.setupView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func refreshCount() {
    let images = ImageStore.shared.getImages()
    if (images.count > 0) {
         thumbnailView.image = UIImage(data: images[0])
    }
    photosText.text = "Photos (\(images.count))"
    self.layoutIfNeeded()
    self.reloadInputViews()
  }
  
  private func setupView() {
    let images = ImageStore.shared.getImages()
    self.height(180).width(150)
    self.backgroundColor = .black
    self.layer.borderColor = UIColor.systemGray.cgColor
    self.layer.borderWidth = 1
    self.sv(thumbnailView, photosText)
    
    thumbnailView.Top == self.Top
    thumbnailView.fillHorizontally()
    thumbnailView.Bottom == photosText.Top - 10
    
    if (images.count > 0) {
      thumbnailView.image = UIImage(data: images[0])
    }
    
    thumbnailView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    thumbnailView.clipsToBounds = true
    thumbnailView.contentMode = .scaleAspectFill
    
    photosText.fillHorizontally()
    photosText.Bottom == self.Bottom - 8
    photosText.textAlignment = .center
    photosText.text = "Photos (\(images.count))"
    photosText.isEnabled = false
    photosText.font = UIFont.boldSystemFont(ofSize: 18)
    photosText.textColor = .systemBlue
  }
}

class MainViewController: UIViewController {
  var selectedAssets = [TLPHAsset]()
  let photosAlbumView = PhotosAlbumView()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = UIColor.init(red: 1/26, green: 0, blue: 0, alpha: 1)
    let button = UIButton(type: .contactAdd)
    let albumsView = UIView()
    
    self.view.sv(button, albumsView)
    albumsView.sv(photosAlbumView)
    
    photosAlbumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showHiddenPhotos(_:))))
    photosAlbumView.isUserInteractionEnabled = true
    
    // style button
    albumsView.Top == self.view.safeAreaLayoutGuide.Top + 50
    albumsView.Left == self.view.safeAreaLayoutGuide.Left + 20
    albumsView.Right == self.view.safeAreaLayoutGuide.Right - 20
    albumsView.Bottom == button.Top
    
    button.Bottom == self.view.safeAreaLayoutGuide.Bottom - 20
    button.centerHorizontally()
    button.text(" Hide photos")
    
    button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      asset.cloudImageDownload(progressBlock: { (progress) in
        print("==== progress ", progress)
      }) { (downloadedImage) in
        if let image = downloadedImage?.jpegData(compressionQuality: .greatestFiniteMagnitude) {
          assetsToBeDeleted.add(phAsset)
          uiImages.append(image)
          if (uiImages.count == self.selectedAssets.count) {
            ImageStore.shared.storeImages(imagesToBeStored: uiImages)
            self.deleteAssets(assetsToBeDeleted: assetsToBeDeleted)
            self.photosAlbumView.refreshCount()
          }
        }
      }
    }
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
