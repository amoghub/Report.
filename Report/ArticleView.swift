//
//  ArticleView.swift
//  Report.
//
//  Created by Amogh Kalyan on 11/28/21.
// 

import UIKit
import SafariServices

var temp_url = String()

class ArticleView: UIViewController {
    
    var checker = 0
    
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var clicktextLabel: UILabel!
    @IBOutlet var linkButton_: UIButton!
    
    
    @IBOutlet var buttonConstraint: NSLayoutConstraint!
    @IBOutlet var clickConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConstraint.constant -= view.bounds.width
        //clickConstraint.constant -= view.bounds.width
        
        UIView.animate(withDuration: 1.0, animations: {
            self.clicktextLabel.alpha = 0.0
            self.linkButton_.alpha = 0.0
            self.descriptionLabel.alpha = 0.0
            self.imageLabel.alpha = 0.0
            self.titleLabel.alpha = 0.0
            self.dateLabel.alpha = 0.0
        })
        
        UIView.animate(withDuration: 2.0, animations: {
            self.linkButton_.alpha = 0.0
        })
        
        // DailyView listeners
        NotificationCenter.default.addObserver(self, selector: #selector(didGetTitle(_ :)), name: Notification.Name("title"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDescription(_ :)), name: Notification.Name("description"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImage(_ :)), name: Notification.Name("image"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetURL(_ :)), name: Notification.Name("url"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSource(_ :)), name: Notification.Name("source"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDate(_ :)), name: Notification.Name("date"), object: nil)
        
        // SearchView Listeners
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetTitle(_ :)), name: Notification.Name("searchtitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetDescription(_ :)), name: Notification.Name("searchdescription"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetImage(_ :)), name: Notification.Name("searchimage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetURL(_ :)), name: Notification.Name("searchurl"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetSource(_ :)), name: Notification.Name("searchsource"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDidGetDate(_ :)), name: Notification.Name("searchdate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if checker == 0 {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.buttonConstraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            checker += 1
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.clicktextLabel.alpha = 1.0
            self.linkButton_.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
            self.imageLabel.alpha = 1.0
            self.titleLabel.alpha = 1.0
            self.dateLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 2.0, animations: {
            self.linkButton_.alpha = 1.0
        })
    }
    
    
    // Link button that goes to a web browser
    @IBAction func linkButton(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: temp_url)!)
        present(vc, animated: true)
    }
    
    
    // DailyView Functions
    @objc func didGetTitle(_ notification: Notification) {
        let title = notification.object as! String?
        
        titleLabel.font = UIFont(name: "Charter Bold", size: 20)
        titleLabel.text = title
    }
    
    @objc func didGetDescription(_ notification: Notification) {
        let description = notification.object as! String?
        descriptionLabel.text = description
    }
    
    @objc func didGetURL(_ notification: Notification) {
        temp_url = (notification.object as! String?)!
        clicktextLabel.text = "Click on link to go to page!"
    }
    
    @objc func didGetImage(_ notification: Notification) {
        let urlString = (notification.object as! String?)!
        
        let url = URL(string: urlString)!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            let image = UIImage(data: imageData)
            imageLabel.image = image
        }
    }
    
    @objc func didGetSource(_ notification: Notification) {
        let source = notification.object as! String?
        sourceLabel.text = "Report From: " + source!
    }
    
    @objc func didGetDate(_ notification: Notification) {
        let temp = notification.object as! String?

        let ISOdateFormatter = ISO8601DateFormatter()
        let date = ISOdateFormatter.date(from: temp!)
        let dateFormatter = DateFormatter()

        // Format Date
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        // Convert date to string
        let dateStr = dateFormatter.string(from: date!)
        dateLabel.text = dateStr
    }
    
    
    // SearchView Functions for listeners
    @objc func searchDidGetTitle(_ notification: Notification) {
        let title = notification.object as! String?
        
        titleLabel.font = UIFont(name: "Charter Bold", size: 20)
        titleLabel.text = title
    }
    
    @objc func searchDidGetDescription(_ notification: Notification) {
        let description = notification.object as! String?
        descriptionLabel.text = description
    }
    
    @objc func searchDidGetImage(_ notification: Notification) {
        let urlString = (notification.object as! String?)!
        
        let url = URL(string: urlString)!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            let image = UIImage(data: imageData)
            imageLabel.image = image
        }
    }
    
    @objc func searchDidGetURL(_ notification: Notification) {
        temp_url = (notification.object as! String?)!
        clicktextLabel.text = "Click on link to go to page!"
    }
    
    @objc func searchDidGetSource(_ notification: Notification) {
        let source = notification.object as! String?
        sourceLabel.text = "Report From: " + source!
    }
    
    @objc func searchDidGetDate(_ notification: Notification) {
        let temp = notification.object as! String?

        let ISOdateFormatter = ISO8601DateFormatter()
        let date = ISOdateFormatter.date(from: temp!)

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date/Time Style
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        // Convert Date to String
        let dateStr = dateFormatter.string(from: date!)
        dateLabel.text = dateStr
    }
    
}
