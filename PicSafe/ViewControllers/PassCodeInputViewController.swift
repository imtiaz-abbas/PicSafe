//
//  PassCodeInputViewController.swift
//  PicSafe
//
//  Created by Able on 30/08/19.
//  Copyright © 2019 Able. All rights reserved.
//

import UIKit
import Stevia

enum PassCodeState {
  case initial
  case enterPasscodeToRegister
  case reEnterPasscodeToRegister
  case enterPasscodeToLogin
}

class KeyView: UIView {
  
  var key: Int = 0
  var keyV = UIView()
  var keyLabel = UILabel()
  var delegate: KeyInputDelegate?
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(key: Int) {
    self.sv(keyV)
    self.key = key
    keyV.height(70).width(70).centerVertically().centerHorizontally()
    keyV.backgroundColor = .black
    keyV.layer.cornerRadius = 35
    keyV.layer.borderWidth = 1
    
    keyV.sv(keyLabel)
    keyLabel.centerHorizontally().centerVertically()
    if key == -1 {
      keyLabel.text = "<"
    } else {
      keyLabel.text = "\(key)"
      keyV.layer.borderColor = UIColor.white.cgColor
    }
    keyLabel.textColor = UIColor.white
    keyLabel.font = keyLabel.font.withSize(20)
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.handleKeyInput(key: self.key)
  }
}

protocol KeyInputDelegate {
  func handleKeyInput(key: Int)
}

class PassCodeInputViewController: UIViewController {
  var passCode: String = ""
  var passCodeState: PassCodeState = .initial
  
  var passcode1: String = ""
  var passcode2: String = ""
  
  var contentView = UIView()
  var keyPadView = UIView()
  var passCodeView = UIView()
  var titleLabel = UILabel()
  var keysView1 = UIView()
  var keysView2 = UIView()
  var keysView3 = UIView()
  var keysView4 = UIView()
  var inputView1 = UIView()
  var inputView2 = UIView()
  var inputView3 = UIView()
  var inputView4 = UIView()
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
  let backKey = KeyView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    UserDefaults.standard.removeObject(forKey: "passCode")
    start()
    
    setupContentView()
    setupKeypadView()
    setupPassCodeView()
  }
  
  func start() {
    
    let passCodeSet = UserDefaults.standard.string(forKey: "passCode") ?? ""
    
    if passCodeSet == "" {
      passCodeState = .enterPasscodeToRegister
    } else {
      passCodeState = .enterPasscodeToLogin
    }
  }
  
  func setupContentView() {
    view.sv(contentView)
    contentView.Top == self.view.safeAreaLayoutGuide.Top
    contentView.Bottom == self.view.safeAreaLayoutGuide.Bottom
    contentView.Left == self.view.safeAreaLayoutGuide.Left
    contentView.Right == self.view.safeAreaLayoutGuide.Right
  }
  func setupPassCodeView() {
    let passCodeViewContainer = UIView()
    contentView.sv(passCodeViewContainer)
    passCodeViewContainer.Top == contentView.Top + 100
    passCodeViewContainer.Bottom == keyPadView.Top
    passCodeViewContainer.fillHorizontally()
    
    passCodeViewContainer.sv(titleLabel, passCodeView)
    
    titleLabel.centerHorizontally()
    titleLabel.Top == passCodeViewContainer.Top + 20
    titleLabel.text = "Enter Passcode"
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.font = titleLabel.font.withSize(20)
    
    
    passCodeView.height(100).centerHorizontally().centerVertically()
    
    passCodeView.sv(inputView1.style(inputViewStyle), inputView2.style(inputViewStyle), inputView3.style(inputViewStyle), inputView4.style(inputViewStyle))
    
    
    inputView1.Left == passCodeView.Left
    inputView2.Left == inputView1.Right + 20
    inputView3.Left == inputView2.Right + 20
    inputView4.Left == inputView3.Right + 20
    
    passCodeView.Right == inputView4.Right
    
  }
  
  func inputViewStyle(view: UIView) {
    view.height(10).width(10)
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 0.5
    view.layer.cornerRadius = 5
    view.centerVertically()
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
    leftKey.delegate = self
    centerKey.setupView(key: keyValues[1])
    centerKey.delegate = self
    rightKey.setupView(key: keyValues[2])
    rightKey.delegate = self
  }
  
  func setupKeyView4() {
    let keyWidth = (UIScreen.main.bounds.width - 40) / 3
    
    let emptyView = UIView()
    
    keysView4.sv(emptyView, key0, backKey)
    
    
    emptyView.width(keyWidth).fillVertically()
    key0.width(keyWidth).fillVertically()
    backKey.width(keyWidth).fillVertically()
    emptyView.Left == keysView4.Left
    key0.Left == emptyView.Right
    backKey.Left == key0.Right
    backKey.Right == keysView4.Right
    
    backKey.setupView(key: -1)
    backKey.delegate = self
    
    key0.setupView(key: 0)
    key0.delegate = self
    
    keysView4.sv(key0)
  }
  
  func setPasscode() {
    if passCodeState == .enterPasscodeToLogin {
      if passCode == UserDefaults.standard.string(forKey: "passCode") ?? "" {
        goToNextScreen()
      } else {
        wobblePassCode()
        resetInput()
      }
    } else if passCodeState == .enterPasscodeToRegister {
      passcode1 = passCode
      passCode = ""
      titleLabel.text = "Re-enter Passcode"
      passCodeState = .reEnterPasscodeToRegister
      resetInput()
    } else if passCodeState == .reEnterPasscodeToRegister {
      passcode2 = passCode
      if passcode1 == passcode2 {
        UserDefaults.standard.set(passCode, forKey: "passCode")
        reset()
        goToNextScreen()
      } else {
        titleLabel.text = "Passcode didn't match. Enter Passcode"
        wobblePassCode()
        reset()
        resetInput()
      }
    }
  }
  
  func resetInput() {
    passCode = ""
    inputView1.backgroundColor = .clear
    inputView2.backgroundColor = .clear
    inputView3.backgroundColor = .clear
    inputView4.backgroundColor = .clear
  }
  
  func reset() {
    passCode = ""
    passcode1 = ""
    passcode2 = ""
    start()
  }
  
  func goToNextScreen() {
    self.present(MainViewController(), animated: true) {
      print("Navigated to main screen")
    }
  }
  
  func wobblePassCode() {
    UIView.animate(withDuration: 0.05, animations: {
      self.passCodeView.transform = CGAffineTransform(translationX: 10, y: 0)
    }) { (c) in
      if c {
        
        UIView.animate(withDuration: 0.1, animations: {
          self.passCodeView.transform = CGAffineTransform(translationX: -10, y: 0)
        }, completion: { c1 in
          if c1 {
            UIView.animate(withDuration: 0.05, animations: {
              self.passCodeView.transform = .identity
            }, completion: nil)
          }
        })
      }
    }
  }
  
}


// protocol extensions
extension PassCodeInputViewController: KeyInputDelegate {
  func handleKeyInput(key: Int) {
    if passCode.count == 4 && key != -1 {
      self.wobblePassCode()
      return
    }
    if key == -1 {
      passCode = String(passCode.dropLast())
    } else {
      passCode = "\(passCode)\(key)"
    }
    switch passCode.count {
    case 0:
      inputView1.backgroundColor = .clear
      inputView2.backgroundColor = .clear
      inputView3.backgroundColor = .clear
      inputView4.backgroundColor = .clear
      break
    case 1:
      inputView1.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView2.backgroundColor = .clear
      inputView3.backgroundColor = .clear
      inputView4.backgroundColor = .clear
      break
    case 2:
      inputView1.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView2.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView3.backgroundColor = .clear
      inputView4.backgroundColor = .clear
      break
    case 3:
      inputView1.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView2.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView3.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView4.backgroundColor = .clear
      break
    case 4:
      inputView1.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView2.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView3.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      inputView4.backgroundColor = UIColor.white.withAlphaComponent(0.8)
      
      self.setPasscode()
      break
    default:
      break
    }
  }
}
