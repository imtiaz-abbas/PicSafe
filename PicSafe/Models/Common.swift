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
  
  func storeImages(images: [Data], forKey key: String, noExisting: Bool = false) {
    var jpegRepresentations: [Data] = []
    images.forEach { (image) in
      jpegRepresentations.append(image)
    }
    let existingImages = retrieveImages(forKey: key)
    
    // append existing images to newly added images to jpegRepresentations array
    if (!noExisting) {
      existingImages?.forEach({ (image) in
        jpegRepresentations.append(image)
      })
    }
    // store array of jpegRepresentations to UserDefaults
    UserDefaults.standard.set(jpegRepresentations, forKey: key)
  }
  
  func retrieveImages(forKey key: String) -> [Data]? {
    if let imagesData = UserDefaults.standard.object(forKey: key) as? [Data] {
      return imagesData
    } else {
      return []
    }
  }
  
  public func storeImage(image: Data, forKey key: String, withStorageType storageType: StorageType) {
    
    switch storageType {
    case .fileSystem:
      if let filePath = filePath(forKey: key) {
        do  {
          try image.write(to: filePath,
                                       options: .atomic)
        } catch let err {
          print("Saving file resulted in error: ", err)
        }
      }
      
    case .userDefaults:
      UserDefaults.standard.set(image, forKey: key)
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


