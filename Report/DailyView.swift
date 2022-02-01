//
//  ViewController.swift
//  Report.
//
//  Created by Amogh Kalyan on 11/28/21.
//  For daily news updates on Report

import UIKit

var article_arr = [Article]()

class DailyView: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! // collection view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        requestURL()
    }
    
    func requestURL() {
        article_arr = []

        //API REQUEST NEWSAPI 15-20 ARTICLES
        var second_Url = String()
        var second_Image = String()
        var second_Source = String()
        var second_Description = String()
        let configuration_2 = URLSessionConfiguration.default
        let url_API2 = URL(string:"https://newsapi.org/v2/top-headlines?country=us&apiKey=[REDACTED]")!
        let session_2 = URLSession(configuration: configuration_2, delegate: nil, delegateQueue: OperationQueue.main)

        let task_2 = session_2.dataTask(with: url_API2, completionHandler: { data_2, response_2, error_2 in
            //print(response)
            
            if error_2 != nil {
                //print(error_2)
                return
            }
            
            else {
                do{
                    let json_2 = try JSONSerialization.jsonObject(with: data_2!, options: [])
                    
                    let eachArticle_2 = json_2 as! [String:Any]
                    let pullArticles_2 = eachArticle_2["articles"] as! NSArray
                    
                    do {
                        for i in pullArticles_2 {
                            let temp_2 = i as! [String:Any]
                            
                            // CHECKS FOR NSNULL VALUES
                            if temp_2["urlToImage"] as? String != nil {
                                second_Image = temp_2["urlToImage"] as! String
                            }
                            else {
                                continue
                            }
                            
                            if temp_2["url"] as? String != nil {
                                second_Url = temp_2["url"] as! String
                            }
                            else {
                                continue
                            }
                            
                            let second_dict = temp_2["source"] as! NSDictionary
                            if second_dict["name"] as? String != nil {
                                second_Source = second_dict["name"] as! String
                            }
                            else {
                                continue
                            }
                            
                            if temp_2["description"] as? String != nil {
                                second_Description = temp_2["description"] as! String
                            }
                            else {
                                continue
                            }
                            
                            let second_Title = temp_2["title"] as! String
                            let second_PublishedAt = temp_2["publishedAt"] as! String
                            
                            let second_Data = Article(title: second_Title, description: second_Description, url: second_Url, image: second_Image, publishedAt: second_PublishedAt, source: second_Source)
                            
                            article_arr.append(second_Data)
                        }
                    }
                    // test code here
                    self.collectionView.reloadData()
                } catch {
                        print("Error during JSON serialization: \(error.localizedDescription)")
                    }
                }
            })
            task_2.resume()
    }
}

// collectionview datasource
extension DailyView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return article_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.view_setup(with: article_arr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Change tabbar to go to ArticleView ViewController
        performSegue(withIdentifier: "switch", sender: self)
        
        // ALL ITEMS BEING SENT TO ARTICLEVIEW VIEWCONTROLLER
        NotificationCenter.default.post(name: Notification.Name("title"), object: article_arr[indexPath.row].title)
        NotificationCenter.default.post(name: Notification.Name("description"), object: article_arr[indexPath.row].description)
        NotificationCenter.default.post(name: Notification.Name("image"), object: article_arr[indexPath.row].image)
        NotificationCenter.default.post(name: Notification.Name("url"), object: article_arr[indexPath.row].url)
        NotificationCenter.default.post(name: Notification.Name("source"), object: article_arr[indexPath.row].source)
        NotificationCenter.default.post(name: Notification.Name("date"), object: article_arr[indexPath.row].publishedAt)
    }
}

// constraints for collectionview
extension DailyView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 420, height: 160)
    }
}
