//
//  LogoutViewController.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/12/05.
//

import UIKit
import Firebase
import SVProgressHUD

class LogoutViewController: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //ログインボタン
    @IBAction func loginBtn(_ sender: Any) {
        if let address = mailText.text, let password = passwordText.text {

                      // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
                      if address.isEmpty || password.isEmpty {
                          return
                      }

                    Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "ログインに失敗しました")
                            return
                        }
                        print("DEBUG_PRINT: ログイン成功")
                        SVProgressHUD.showSuccess(withStatus: "ログインに成功しました")
                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
        }
        
    }

    
    

    
    



        
 

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
