//
//  HomeViewController.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/11/25.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    //addボタン
    @IBOutlet weak var addBtn: UIButton!
    @IBAction func addBtnClick(_ sender: Any) {
    }
    
    //ハンバーガーボタン
    @IBAction func sideBtnClick(_ sender: Any) {
    }
    
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    //Firestoreの投稿データの格納場所
    let postsRef = Firestore.firestore().collection("posts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchBar()
        //addボタンの見た目
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        addBtn.frame = CGRect(x: screenWidth/2 - 30, y: screenHeight/8*7, width: 60, height: 60)
        addBtn.layer.cornerRadius = 30
    }
    
    //Home画面が表示されるたびに毎回呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理（匿名認証でユーザーidを発行）
            Auth.auth().signInAnonymously() { authResult, error in
                guard let user = authResult?.user else {
                    return
                }
                print(user.uid)
            }
        }else{
            //currentUserが存在する場合（＝ログイン済みの場合）、listenerを登録して投稿データの更新を監視する
            listener = postsRef
                .whereField("isArchived", isNotEqualTo: true)
 //               .order(by: "date", descending: true)
                .addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
//            postsRef.whereField("isArchived", in: [false]).getDocuments{ (querySnapshot, error) in
//                if let error = error {
//                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
//                    return
//                }

                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    //Home画面が閉じるときに毎回呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        //セルにデータを設定する
        cell.setPostData(postArray[indexPath.row])
        return cell
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "cellSegue" {
            let registerViewController:RegisterViewController = segue.destination as! RegisterViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            registerViewController.titleRecieved = postArray[indexPath!.row].title!
            registerViewController.memoRecieved = postArray[indexPath!.row].memo!
            registerViewController.idRecieved = postArray[indexPath!.row].id
            
        }
    }
    
    
    
    
    // セルが削除不可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .none
    }
    
    
    //セルのスワイプ時に呼ばれるメソッド（アーカイブ用）
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 編集処理
            let archiveAction = UIContextualAction(style: .normal, title: "覚えた") { (action, view, completionHandler) in
              // 編集処理を記述
                let postData = self.postArray[indexPath.row]
                var updateValue: Bool
                //まだアーカイブされてなければ、isArchivedをtrueにする
                if postData.isArchived == false {
                    updateValue = true
                    print("アーカイブをtrueに")
                }else{
                    //既にアーカイブされていたら、isArchivedをfalseにする
                    updateValue = false
                    print("アーカイブをfalseに")
                }
               //更新データをFirebaseに書き込む
                self.postsRef.document(postData.id).updateData(["isArchived": updateValue])
            // 実行結果に関わらず記述
            completionHandler(true)
            }
        //アーカイブボタンの色と画像
        archiveAction.backgroundColor = UIColor.lightGray
        archiveAction.image = UIImage(systemName: "archivebox")
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [archiveAction])
    }
    
    //以下、サーチバー関連
    func setupSearchBar(){
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "検索"
            searchBar.tintColor = UIColor.gray
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    // サーチバーで編集が開始されたら、キャンセルボタンを有効にする
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    // サーチバーのキャンセルボタンが押されたら、キャンセルボタンを無効にしてフォーカスを外す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    //検索機能の追加
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //サーチテキストが空欄なら、検索結果に全て表示
        if searchText == "" {
           listener = postsRef
            .whereField("isArchived", isNotEqualTo: true)
//            .order(by: "date", descending: true)
            .addSnapshotListener(){ (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                self.postArray = querySnapshot!.documents.map { document in
                    let postData = PostData(document: document)
                    print("DEBUG_PRINT: 文字無しの検索結果を反映しました。")
                    return postData
                }
            self.tableView.reloadData()
            }
        }else{
            //サーチテキストに文字が入力されたら、それを含むpostDataを返す
            postsRef.whereField("title", in:["\(searchText)"]).getDocuments{ (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }else{
                    print("DEBUG_PRINT: \(querySnapshot!.documents.count)個のドキュメントを取得")
                    self.postArray = querySnapshot!.documents.map { document in
                        let postData = PostData(document: document)
                        print("DEBUG_PRINT: 文字ありの検索結果を反映しました。")
                        return postData
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}
