//
//  LoginViewController.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/11/25.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createAccountBtn(_ sender: Any) {
        if let address = mailText.text, let password = passwordText.text, let displayName = nameText.text {
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功")
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                    }
                }
                //匿名認証アカウントとの紐付け
//                let credential = EmailAuthProvider.credential(withEmail: address, password: password)
//                self.dismiss(animated: true, completion: nil)
//                user?.link(with: credential) { authResult, error in
//                    print("DEBUG_PRINT: 匿名認証との紐付けに失敗")
//                    return
//                }
//                print("DEBUG_PRINT: 匿名認証との紐付けに成功")
                SVProgressHUD.showSuccess(withStatus: "アカウントを作成しました")
                self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    //アカウント削除ボタン
    @IBAction func deleteAccountBtn(_ sender: Any) {
            // ログイン中のユーザーアカウントを削除する。
            Auth.auth().currentUser?.delete {  (error) in
                // エラーが無ければ、ログイン画面へ戻る
                if error == nil {
                    print("DEBUG_PRINT: アカウント削除に成功")
                    SVProgressHUD.showSuccess(withStatus: "アカウント削除に成功しました")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print("エラー：\(String(describing: error?.localizedDescription))")
                    SVProgressHUD.showError(withStatus: "アカウント削除に失敗しました")
                }
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
            
