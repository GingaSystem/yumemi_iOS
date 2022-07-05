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
    var urlSessionTask: URLSessionTask? //オプショナル型→nilが入ることがある
    var searchingWord: String!
    var url: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlSessionTask?.cancel()
    }
    
    /*func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     searchingWord = searchBar.text!
     if searchingWord.count != 0 {
     url = "https://api.github.com/search/repositories?q=\(searchingWord!)"
     urlSessionTask = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
     if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
     if let items = obj["items"] as? [[String: Any]] {
     self.repository = items
     DispatchQueue.main.async {
     self.tableView.reloadData()
     }
     }
     }
     }
     // これ呼ばなきゃリストが更新されません
     urlSessionTask?.resume()
     }
     }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchingWord = searchBar.text!
        if searchingWord.count != 0 {//searchingWordの文字数が0でない時実行される
            url = "https://api.github.com/search/repositories?q=\(searchingWord!)"
            urlSessionTask = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
                guard let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] else { return }//objがnilだったら処理を終了
                guard let items = obj["items"] as? [[String: Any]] else { return } //itemsがnilだったら処理を終了
                self.repository = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            // これ呼ばなきゃリストが更新されません
            urlSessionTask?.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let dtl = segue.destination as! ViewController2
            dtl.viewController1 = self
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
