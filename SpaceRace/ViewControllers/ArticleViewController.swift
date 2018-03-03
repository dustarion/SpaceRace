//
//  ArticleViewController.swift
//  SpaceRace
//
//  Created by Dalton Ng on 14/2/18.
//  Copyright © 2018 AppsLab. All rights reserved.
//

import UIKit
import ParallaxHeader
import Kingfisher
import Atributika

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //@IBOutlet weak var contentTextView: UITextView!
    //@IBOutlet weak var ArticleView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    
    var articleTitle : String?
    var articleDate : String?
    var articleDescription : String?
    var webLink : String?
    var articleCover : String?
    let webV = UIWebView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the top title
        self.navigationItem.title = articleTitle
        
        print(webLink!)
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //create view as header view
        let coverView = UIView()
        let overlayView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        overlayView.image = #imageLiteral(resourceName: "articleOverlay")
        overlayView.contentMode = .scaleAspectFill
        
        let dateLabel = UILabel(frame: CGRect(x: 30, y: (screenHeight - 425), width: (screenWidth - 50), height: 25))
        dateLabel.textColor = UIColor.white
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textAlignment = .left
        dateLabel.font =  UIFont (name: "Avenir-Medium", size: 18)
        dateLabel.text = articleDate
        
        /*
        // To Do :  Add unsplash attribution code
        // Setting up our unsplash attribution ( if any )
        let unsplashLabel = UILabel(frame: CGRect(x: 30, y: (screenHeight - 50), width: (screenWidth - 60), height: 26))
        unsplashLabel.textColor = UIColor.white
        unsplashLabel.backgroundColor = UIColor.clear
        unsplashLabel.textAlignment = .left
        unsplashLabel.font =  UIFont (name: "Avenir-Light", size: 14)!
        //unsplashLabel.isUserInteractionEnabled = false
        //unsplashLabel.isScrollEnabled = false
        //unsplashLabel.isEditable = false
        //unsplashLabel.isSelectable = false
        unsplashLabel.text = "Photo by "
        //unsplashLabel.url = "https://unsplash.com/@anniespratt?utm_source=your_app_name&utm_medium=referral"
        //Photo by <a href="https://unsplash.com/@anniespratt?utm_source=your_app_name&utm_medium=referral">Annie Spratt</a> on <a href="https://unsplash.com/?utm_source=your_app_name&utm_medium=referral">Unsplash</a>
        */
 
        let coverLabel = UITextView(frame: CGRect(x: 27, y: (screenHeight - 400), width: (screenWidth - 50), height: 400))
        // If we want to use a label, use : coverLabel.numberOfLines = 0
        coverLabel.textColor = UIColor.white
        coverLabel.backgroundColor = UIColor.clear
        coverLabel.textAlignment = .left
        coverLabel.font =  UIFont (name: "Avenir-Black", size: 48)
        coverLabel.isUserInteractionEnabled = false
        coverLabel.isScrollEnabled = false
        coverLabel.isEditable = false
        coverLabel.isSelectable = false
        coverLabel.text = articleDescription
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        imageView.image = #imageLiteral(resourceName: "defaultArticleImage")
        imageView.contentMode = .scaleAspectFill
        
        if ((articleCover == nil) == false ) {
            let url = URL(string: articleCover!)
            imageView.kf.setImage(with: url)
        }
    
        coverView.addSubview(imageView)
        coverView.addSubview(overlayView)
        coverView.addSubview(coverLabel)
        coverView.addSubview(dateLabel)
        //coverView.addSubview(unsplashLabel)
        
        tableView.parallaxHeader.view = coverView
        tableView.parallaxHeader.height = screenHeight
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .topFill
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Extra Layer of Security, ensure HTTPS is used
        let url = webLink?.replacingOccurrences(of: "http:", with: "https:", options: .literal, range: nil)
        print(url!)
        webV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webV.loadRequest(NSURLRequest(url: NSURL(string: url!)! as URL) as URLRequest)
        webV.delegate = nil
        webV.scrollView.isScrollEnabled = false
        webV.scrollView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // Custom row height
        return UIScreen.main.bounds.height;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(webV)
        
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print("Scrolled to end")
            webV.scrollView.isScrollEnabled = true
            webV.scrollView.bounces = true
        }
        if distanceFromBottom > height {
            webV.scrollView.isScrollEnabled = false
            webV.scrollView.bounces = false
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    //@available(iOS 10.0, *)
    //func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    //    return true
    //}
    
    @IBAction func share(_ sender: Any) {
        let firstActivityItem : NSURL = NSURL(string: webLink!)!
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Exclude the following
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
