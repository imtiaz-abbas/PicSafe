//
//  ImageStorage.swift
//  PicSafe
//
//  Created by Imtiaz Abbas on 29/03/20.
//  Copyright © 2020 Imtiaz Abbas. All rights reserved.
//

import Foundation
import UIKit


class ImageStore {
  static var shared = ImageStore()
  var imagesData: [Data] = []
  
  init() {
    if let x = CommonStorage.shared.retrieveImages(forKey: "bulkHiddenImages"){
      self.imagesData = x
    }
  }
  
  func getImages() -> [Data] {
    return self.imagesData
  }
  
  func removeImage(uiImage: Data) {
    var filteredImages: [Data] = []
    self.imagesData.forEach({ (x) in
      if (x != uiImage) {
        filteredImages.append(x)
      }
    })
    self.imagesData = filteredImages
    CommonStorage.shared.storeImages(images: self.imagesData, forKey: "bulkHiddenImages", noExisting: true)
  }
  
  func storeImages(imagesToBeStored: [Data]) {
    imagesToBeStored.forEach { (x) in
      self.imagesData.append(x)
    }
  }
}
