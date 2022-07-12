//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var repository: [[String: Any]]=[]
    var urlSessionTask: URLSessionTask?
    var searchingWord: String?
    var url: String!
    var index: Int? //!と?：オプショナル型→nilが入ることがある !: 暗黙的アンラップ型
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのRepositoryを検索できます"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlSessionTask?.cancel()
        searchBar.searchTextField.textColor = .black
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchingWord = searchBar.text{ //強制的アンラップをオプショナルバインディングに変更。searchBar.textがnilでない時実行
            if searchingWord.count != 0 && !searchingWord.contains(" ") && isAlphanumeric(searchingWord) { //入力を半角英数に限った。またスペースが入ったときにアプリがクラッシュしないようにした
                let url = "https://api.github.com/search/repositories?q=\(searchingWord)"
                urlSessionTask = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
                    guard let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] else { return }//objがnilだったら処理を終了 検索窓に空白スペースを入れた時アプリが落ちる：Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                    guard let items = obj["items"] as? [[String: Any]] else { return } //itemsがnilだったら処理を終了
                    self.repository = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                // これ呼ばなきゃリストが更新されません
                urlSessionTask?.resume()
            }else{
                searchBar.searchTextField.textColor = .blue
                searchBar.text = "スペース無しの半角英数字で入力して下さい"
            }
        }else{
            searchBar.text = "検索ワードが空です"
        }
    }
    
    //検索された文字が半角英数字である時Trueを返す
    func isAlphanumeric(_ str: String) -> Bool {
        return !str.isEmpty && str.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let dtl = segue.destination as? ViewController2 //強制ダウンキャストas!をas?に変更。dtlがオプショナル型になる
            dtl?.viewController1 = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let rp = repository[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
