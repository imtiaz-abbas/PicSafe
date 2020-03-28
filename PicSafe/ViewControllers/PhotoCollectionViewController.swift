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

protocol ImageCollectionViewCellDelegate {
  func onImageClicked(image: UIImage)
}

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  var images: [UIImage] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @objc func swipeToLogin(sender:UISwipeGestureRecognizer) {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let images = CommonStorage.shared.retrieveImages(forKey: "bulkHiddenImages") {
      self.images = images
    }
    let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLogin))
    leftGesture.direction = .right
    self.view.addGestureRecognizer(leftGesture)
    self.setupViews()
  }
  
  private func setupViews() {
    self.view.subviews.forEach { (x) in
      x.removeFromSuperview()
    }
    let title = UITextView()
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    layout.itemSize = CGSize(width: 100, height: 100)
    
    let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    myCollectionView.dataSource = self
    myCollectionView.delegate = self
    myCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
    myCollectionView.backgroundColor = UIColor.init(red: 1/26, green: 0, blue: 0, alpha: 1)
    
    self.view.sv(title, myCollectionView)
    
    title.Top == self.view.safeAreaLayoutGuide.Top
    title.fillHorizontally()
    title.height(<=70)
    
    myCollectionView.fillHorizontally()
    myCollectionView.Top == title.Bottom
    myCollectionView.Bottom == self.view.Bottom
    
    title.text = "HIDDEN PHOTOS"
    title.textColor = .white
    title.textAlignment = .center
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
    myCell.setupView(uiImage: images[indexPath.row])
    myCell.delegate = self
    return myCell
  }
  
  private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
  {
    print("User tapped on item \(indexPath.row)")
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension PhotoCollectionViewController: ImageCollectionViewCellDelegate {
  func onImageClicked(image: UIImage) {
    let photoDetailViewController = PhotoDetailViewController()
    photoDetailViewController.setImage(image: image)
    navigationController?.pushViewController(photoDetailViewController, animated: true)
  }
}



class ImageCollectionViewCell: UICollectionViewCell {
  var delegate: ImageCollectionViewCellDelegate?
  
  func setupView(uiImage: UIImage) {
    let imageView = UIImageView()
    self.sv(imageView)
    imageView.image = uiImage
    
    // styles
    imageView.Top == self.Top
    imageView.Bottom == self.Bottom
    imageView.Left == self.Left
    imageView.Right == self.Right
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 1
    
    // Gesture recognizer
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
  {
    if let tappedImage = (tapGestureRecognizer.view as! UIImageView).image {
      delegate?.onImageClicked(image: tappedImage)
    }
  }
}
