//
//  PassCodeInputViewController.swift
//  PicSafe
//
//  Created by Able on 30/08/19.
//  Copyright © 2019 Able. All rights reserved.
//

import UIKit
import Stevia

class KeyView: UIView {
  
  var keyV = UIView()
  var keyLabel = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(key: Int) {
    self.sv(keyV)
    keyV.height(70).width(70).centerVertically().centerHorizontally()
    keyV.layer.cornerRadius = 35
    keyV.layer.borderColor = UIColor.white.cgColor
    keyV.layer.borderWidth = 1
    
    keyV.sv(keyLabel)
    keyLabel.centerHorizontally().centerVertically()
    keyLabel.text = "\(key)"
    keyLabel.textColor = UIColor.white
    keyLabel.font = keyLabel.font.withSize(20)
  }
}

class PassCodeInputViewController: UIViewController {
  
  var contentView = UIView()
  var keyPadView = UIView()
  var keysView1 = UIView()
  var keysView2 = UIView()
  var keysView3 = UIView()
  var keysView4 = UIView()
  let key1 = KeyView()
  let key2 = KeyView()
  let key3 = KeyView()
  let key4 = KeyView()
  let key5 = KeyView()
  let key6 = KeyView()
  let key7 = KeyView()
  let key8 = KeyView()
  let key9 = KeyView()
  let key0 = KeyView()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupContentView()
    setupPassCodeView()
    setupKeypadView()
  }
  
  func setupContentView() {
    view.sv(contentView)
    contentView.Top == self.view.safeAreaLayoutGuide.Top
    contentView.Bottom == self.view.safeAreaLayoutGuide.Bottom
    contentView.Left == self.view.safeAreaLayoutGuide.Left
    contentView.Right == self.view.safeAreaLayoutGuide.Right
  }
  func setupPassCodeView() {
    
  }
  
  func setupKeypadView() {
    contentView.sv(keyPadView)
    keyPadView.Bottom == contentView.Bottom
    keyPadView.fillHorizontally()
    keyPadView.height(400)
    
    keyPadView.sv(keysView1, keysView2, keysView3, keysView4)
    keysView1.Top == keyPadView.Top
    keysView1.fillHorizontally(m: 20)
    keysView1.height(100)
    
    keysView2.Top == keysView1.Bottom
    keysView2.fillHorizontally(m: 20)
    keysView2.height(100)
    
    keysView3.Top == keysView2.Bottom
    keysView3.fillHorizontally(m: 20)
    keysView3.height(100)
    
    keysView4.Top == keysView3.Bottom
    keysView4.fillHorizontally(m: 20)
    keysView4.height(100)
    
    setupKeys()
  }
  
  func setupKeys() {
    setupKeyViews(leftKey: key1, centerKey: key2, rightKey: key3, keyValues: [1,2,3])
    setupKeyViews(leftKey: key4, centerKey: key5, rightKey: key6, keyValues: [4,5,6])
    setupKeyViews(leftKey: key7, centerKey: key8, rightKey: key9, keyValues: [7,8,9])
    setupKeyView4()
  }
  
  func setupKeyViews(leftKey: KeyView, centerKey: KeyView, rightKey: KeyView, keyValues: Array<Int>) {
    let keyWidth = (UIScreen.main.bounds.width - 40) / 3
    if keyValues[0] == 1 {
      keysView1.sv(leftKey, centerKey, rightKey)
    } else if keyValues[0] == 4 {
      keysView2.sv(leftKey, centerKey, rightKey)
    } else if keyValues[0] == 7 {
      keysView3.sv(leftKey, centerKey, rightKey)
    } else {
      return
    }
    
    leftKey.width(keyWidth).fillVertically()
    centerKey.width(keyWidth).fillVertically()
    rightKey.width(keyWidth).fillVertically()
    leftKey.Left == keysView1.Left
    centerKey.Left == leftKey.Right
    rightKey.Left == centerKey.Right
    rightKey.Right == keysView1.Right
    
    leftKey.setupView(key: keyValues[0])
    centerKey.setupView(key: keyValues[1])
    rightKey.setupView(key: keyValues[2])
  }
  
  func setupKeyView4() {
    keysView4.sv(key0)
    key0.fillContainer()
    key0.setupView(key: 0)
  }
  
}
