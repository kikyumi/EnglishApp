//
//  RegisterViewController.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/11/25.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var memoText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weblioBtn: UIButton!
    
    //画面遷移時に値を受け取る箱を用意
    var titleRecieved = ""
    var memoRecieved = ""
    var imageRecieved: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面遷移時の値渡し設定
        titleText.text = titleRecieved
        memoText.text = memoRecieved
        imageView.image = imageRecieved
        //メモ欄のデザイン
        memoText.layer.borderWidth = 0.3
        memoText.layer.borderColor = UIColor.gray.cgColor
        memoText.layer.cornerRadius = 9
        
    }
    
    //weblioボタンのクリック
    @IBAction func weblioBtnClick(_ sender: Any) {
        //外部ブラウザでURLを開く
        let searchText = titleText.text
        if searchText == nil{
            return
        }else{
            let url = NSURL(string: "https://ejje.weblio.jp/content/" + searchText!)
            if UIApplication.shared.canOpenURL(url! as URL){
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    //イメージ検索ボタンのクリック
    @IBAction func imgSearchClick(_ sender: Any) {
        //外部ブラウザでURLを開く
        let searchText = titleText.text
        if searchText == nil{
            return
        }else{
            let url = NSURL(string: "https://www.google.com/search?q=" + searchText! + "&tbm=isch")
            if UIApplication.shared.canOpenURL(url! as URL){
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //イメージ追加ボタンのクリック
    @IBAction func imgAddClick(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //イメージピッカーをキャンセルしたときに呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // イメージピッカーで画像を選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil{
            // 選択された画像を取得する
            let myImage = info[.originalImage] as! UIImage
            imageView.image = myImage
            //画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    //Saveボタンのクリック
    @IBAction func saveBtnClick(_ sender: Any) {
        // 投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection("posts").document()
        //投稿データ（辞書形式）のKeyとValueを定義する
        let postDic = [
            "title": self.titleText.text!,
            "memo": self.memoText.text!,
            "date": FieldValue.serverTimestamp(),
        ] as [String : Any]
        //画像があれば、StrageとFireStoreにデータを保存する
        if imageView.image != nil{
            // 画像をJPEG形式に変換する
            let imageData = imageView.image?.jpegData(compressionQuality: 0.75)
            // 画像データの保存場所を定義する
            let imageRef = Storage.storage().reference().child("images").child(postRef.documentID + ".jpg")
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            // Storageに画像をアップロードする
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    // 画像のアップロード失敗
                    print(error!)
                    SVProgressHUD.showError(withStatus: "保存に失敗しました")
                    // 投稿処理をキャンセルし、先頭画面に戻る
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                // FireStoreにデータを保存する
                postRef.setData(postDic)
            }
        }else{
            // 画像がなければ、FireStoreにデータを保存するだけ
            postRef.setData(postDic)
        }
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "保存しました")
        // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
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
