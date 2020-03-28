//
//  PhotoCollectionView.swift
//  PicSafe
//
//  Created by Imtiaz Abbas on 28/03/20.
//  Copyright © 2020 Imtiaz Abbas. All rights reserved.
//

import Foundation
import UIKit
import Stevia

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  var images: [UIImage] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    if let images = CommonStorage.shared.retrieveImages(forKey: "bulkHiddenImages") {
      self.images = images
      self.reloadInputViews()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    layout.itemSize = CGSize(width: 100, height: 100)
    
    let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    myCollectionView.dataSource = self
    myCollectionView.delegate = self
    myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
    myCollectionView.backgroundColor = UIColor.white
    self.view.addSubview(myCollectionView)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath)
    myCell.backgroundColor = UIColor.red
    let imageView = UIImageView()
    myCell.sv(imageView)
    imageView.Top == myCell.Top
    imageView.Bottom == myCell.Bottom
    imageView.Right == myCell.Right
    imageView.Left == myCell.Left
    imageView.image = images[indexPath.row]
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return myCell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
  {
    print("User tapped on item \(indexPath.row)")
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
