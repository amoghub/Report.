//
//  SearchView.swift
//  Report.
//
//  Created by Amogh Kalyan on 11/28/21.
//

import UIKit

var search_arr = [Article]()
var query_temp:String = ""

class SearchView: UIViewController {
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        //self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    // function to search for articles
    @IBAction func searchForArticles() {
        // takes in text from textfield
        let temp:String? = searchField.text
        
        // if text is nothing, display nothing
        if temp == "" {
            query_temp = "https://gnews.io/api/v4/top-headlines?lang=en&token=[REDACTED]"
            searchField.resignFirstResponder()
        }
        
        // if user searches something
        else {
            // formatting for API with spaces
            if temp?.range(of: " ") != nil {
                let new_temp = temp?.replacingOccurrences(of: " ", with: "%20")
                query_temp = "https://gnews.io/api/v4/search?q=" + new_temp! + "&lang=en&token=[REDACTED]"
            }
            
            // formatting for API with regular keyword
            else{
                query_temp = "https://gnews.io/api/v4/search?q=" + temp! + "&lang=en&token=[REDACTED]"
            }
        }
        
        search_arr = []
        
        //API REQUEST
        let configuration = URLSessionConfiguration.default
        let url = URL(string: query_temp)!
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            //print(response)
            
        if error != nil {
            //print(error)
            return
        }

        else {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        
                let eachArticle = json as! [String:Any]
                //let totalArticles = eachArticle["totalArticles"] as! Int
                let pullArticles = eachArticle["articles"] as! NSArray
                        
                for i in pullArticles {
                    let temp = i as! [String:Any]
                    let title = temp["title"] as! String
                    let description = temp["description"] as! String
                    let url = temp["url"] as! String
                    let image = temp["image"] as! String
                    let publishedAt = temp["publishedAt"] as! String
                    
                    let source_dict = temp["source"] as! NSDictionary
                    let source = source_dict["name"] as! String
                    
                    let data = Article(title: title, description: description, url: url, image: image, publishedAt: publishedAt, source: source)
                            
                    //print(data.image)
                    search_arr.append(data)
                    }
                //test code here
                self.searchCollectionView.reloadData()
                }
            
            catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
}


extension SearchView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.view_setup(with: search_arr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Change tabbar to go to ArticleView ViewController
        performSegue(withIdentifier: "switch", sender: self)
        
        // ALL ITEMS BEING SENT TO ARTICLEVIEW VIEWCONTROLLER
        NotificationCenter.default.post(name: Notification.Name("searchtitle"), object: search_arr[indexPath.row].title)
        NotificationCenter.default.post(name: Notification.Name("searchdescription"), object: search_arr[indexPath.row].description)
        NotificationCenter.default.post(name: Notification.Name("searchimage"), object: search_arr[indexPath.row].image)
        NotificationCenter.default.post(name: Notification.Name("searchurl"), object: search_arr[indexPath.row].url)
        NotificationCenter.default.post(name: Notification.Name("searchsource"), object: search_arr[indexPath.row].source)
        NotificationCenter.default.post(name: Notification.Name("searchdate"), object: search_arr[indexPath.row].publishedAt)
    
    }
}

extension SearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 420, height: 270)
    }
}

extension SearchView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // keyboard dismisses if user clicks on return
        searchField.resignFirstResponder()
        searchForArticles()
        
        return true
    }
    
    
}
