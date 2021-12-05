//
//  SideMenuTableViewController.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/12/03.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    //「覚えた」セル
    @IBOutlet weak var archivedMenu: UITableViewCell!
    
    //最初に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーを非表示にする
        navigationController?.setNavigationBarHidden(true, animated: true)
        //ビューの色を指定
        //       view.backgroundColor = #colorLiteral(red: 0.8974301219, green: 0.9686657786, blue: 0.9766247869, alpha: 1)
    }
    
    
    //セルの高さ設定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // セクションの見た目設定
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        // 背景色を変更する
        header.backgroundColor = #colorLiteral(red: 0.3926500082, green: 0.7097555995, blue: 0.7381229997, alpha: 1)  //←なぜか反映されない
        // テキスト色を変更する
        header.textLabel?.textColor = #colorLiteral(red: 0.3926500082, green: 0.7097555995, blue: 0.7381229997, alpha: 1)
    }
    
    // セルの見た目設定
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        cell.backgroundColor = UIColor.clear　//セルの色を透過にする（背面のviewの色が反映される）
        cell.tintColor = #colorLiteral(red: 0.3926500082, green: 0.7097555995, blue: 0.7381229997, alpha: 1)
        cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // それぞれのセクション毎に何行のセルがあるかを返す
        switch section {
        case 0: // 1つ目のセクション
            return 2
        case 1: // 2つ目のセクション
            return 5
        default: // ここが実行されることはないはず
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // それぞれのSectionとrowをタップしたときのアクションを定義
        switch indexPath.section {
        
        case 0:     //1つ目のセクション
            switch indexPath.row {
            case 0:
                print("覚えてないをタップ")
                GlobalVar.shared.archiveBool = true
                dismiss(animated: true, completion: nil)
            case 1:
                print("覚えたをタップ")
                GlobalVar.shared.archiveBool = false
                dismiss(animated: true, completion: nil)
            default:
                return
            }
        case 1:     //2つ目のセクション
            switch indexPath.row {
            case 0:
                print("評価するをタップ")
            case 1:
                print("シェアをタップ")
            case 2:
                print("使い方タップ")
                let howtoView = self.storyboard?.instantiateViewController(withIdentifier: "Howto") as! HomeViewController
                    self.present(howtoView, animated: true, completion: nil)
            case 3:
                print("アカウント管理タップ")
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    self.present(loginView, animated: true, completion: nil)
            case 4:
                print("ログイン/ログアウトタップ")
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "Logout") as! LogoutViewController
                    self.present(loginView, animated: true, completion: nil)
            default:
                return
            }
        default:
            return
        }
        
    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    //        cell.textLabel!.text = "Row \(indexPath.row)"
    //        // Configure the cell...
    //
    //        return cell
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
