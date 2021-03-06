//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    @IBOutlet weak var wachersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    var viewController1: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let index = viewController1.index else { return }//viewController1.indexがnilの時は処理を終了
        let repository = viewController1.repository[index]
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        stargazersLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        wachersLabel.text = "\(repository["watchers_count"] as? Int ?? 0) watchers" //typoを直しました
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }
    
    func getImage(){
        guard let index = viewController1.index else { return } //viewController1.indexがnilの時は処理を終了
        let repository = viewController1.repository[index]
        titleLabel.text = repository["full_name"] as? String
        guard let owner = repository["owner"] as? [String: Any] else { return }
        guard let imgURL = owner["avatar_url"] as? String else { return }
        URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
            if let img = UIImage(data: data!){ //強制アンラップをオプショナルバインディングに変更
                DispatchQueue.main.async {
                    self.imageLabel.image = img
                }
            }
        }.resume()
    }
}
