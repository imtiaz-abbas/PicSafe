//
//  MainViewController.swift
//  PicSafe
//
//  Created by imtiaz abbas on 02/09/19.
//  Copyright © 2019 Able. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    let titleLabel = UILabel()
    
    self.view.sv(titleLabel)
    titleLabel.text = "SUCCESSFUL"
    titleLabel.font = titleLabel.font.withSize(30)
    titleLabel.textColor = .black
    titleLabel.centerVertically().centerHorizontally()
  }
  
}
