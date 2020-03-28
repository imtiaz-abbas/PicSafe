//
//  Common.swift
//  PicSafe
//
//  Created by Imtiaz Abbas on 28/03/20.
//  Copyright © 2020 Imtiaz Abbas. All rights reserved.
//

import Foundation
import UIKit


enum StorageType {
  case userDefaults
  case fileSystem
}

class CommonStorage {
  static let shared = CommonStorage()
  
  public func storeNumber(count: Int, forKey key: String) {
    UserDefaults.standard.set(count, forKey: key)
  }
  
  public func retrieveNumber(forKey key: String) -> Int {
    if let count = UserDefaults.standard.object(forKey: key) as? Int {
      return count
    }
    return 0
  }
  
  func storeImages(images: [UIImage], forKey key: String) {
    var jpegRepresentations: [Data] = []
    images.forEach { (image) in
      if let jpegRepresentation = image.jpegData(compressionQuality: .greatestFiniteMagnitude) {
        jpegRepresentations.append(jpegRepresentation)
      }
    }
    UserDefaults.standard.set(jpegRepresentations, forKey: key)
  }
  
  func retrieveImages(forKey key: String) -> [UIImage]? {
    var uiImages: [UIImage] = []
    if let imagesData = UserDefaults.standard.object(forKey: key) as? [Data] {
      imagesData.forEach({ (imageData) in
        if let image = UIImage(data: imageData) {
          uiImages.append(image)
        }
      })
      return uiImages
    } else {
      return []
    }
  }
  
  public func storeImage(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
    if let jpegRepresentation = image.jpegData(compressionQuality: .greatestFiniteMagnitude) {
      switch storageType {
      case .fileSystem:
        if let filePath = filePath(forKey: key) {
          do  {
            try jpegRepresentation.write(to: filePath,
                                        options: .atomic)
          } catch let err {
            print("Saving file resulted in error: ", err)
          }
        }
        
      case .userDefaults:
        UserDefaults.standard.set(jpegRepresentation, forKey: key)
      }
    }
  }

  public func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
    switch storageType {
    case .fileSystem:
      if let filePath = filePath(forKey: key),
          let fileData = FileManager.default.contents(atPath: filePath.path),
          let image = UIImage(data: fileData) {
          return image
      }
    case .userDefaults:
      if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
        let image = UIImage(data: imageData) {
        return image
      }
    }
    return nil
  }

  private func filePath(forKey key: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentURL = fileManager.urls(for: .documentDirectory,
                                             in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
    
    return documentURL.appendingPathComponent(key + ".png")
  }
}


