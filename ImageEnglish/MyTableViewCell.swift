//
//  MyTableViewCell.swift
//  ImageEnglish
//
//  Created by 菊川 由美 on 2021/11/25.
//

import UIKit
import FirebaseStorageUI

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        myImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child("images").child(postData.id + ".jpg")
        myImageView.sd_setImage(with: imageRef)
        // タイトルの表示
        self.titleLabel.text = "\(postData.title!)"
        // メモの表示
        self.memoLabel.text = "\(postData.memo!)"
        
    }

}
