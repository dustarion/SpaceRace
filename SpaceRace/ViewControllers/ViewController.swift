//
//  ViewController.swift
//  SpaceRace
//
//  Created by Dalton Ng on 13/2/18.
//  Copyright © 2018 AppsLab. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Kingfisher
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Defining Outlets
    @IBOutlet weak var tableViewNews: UITableView!
    
    // Defining Variables
    var newsList = [NewsModel]()
    var titleToPass:String!
    var imageLinkToPass:String!
    var linkToPass:String!
    var unplashAuthorName:String?
    var unsplashAuthorLink:String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We're about to transition to the article view controller, push all the data we need to display along with it.
        let indexPath = tableViewNews.indexPathForSelectedRow
        print("Selected cell #\(indexPath!.row)!")
        
        let news: NewsModel
    
        news = newsList[(indexPath?.row)!]
        
        let titleToPass = news.title
        let linkToPass = news.link
        let descriptionToPass = news.description
        let imageLinkToPass = news.thumbnail
        let dateToPass = news.pubDate
        
        if let destinationViewController = segue.destination as? ArticleViewController {
            destinationViewController.articleTitle = titleToPass
            destinationViewController.webLink = linkToPass
            destinationViewController.articleDescription = descriptionToPass
            destinationViewController.articleCover = imageLinkToPass
            destinationViewController.articleDate = dateToPass
        }
        
        // Make the button look like <
        let backItem = UIBarButtonItem()
        backItem.title = ""
        // This will show in the next view controller being pushed
        navigationItem.backBarButtonItem = backItem
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the Navigation Bar Title to F E E D
        self.navigationItem.title = "F E E D"
        //addBlurEffect(toView: self.navigationController?.navigationBar)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        var bounds = self.navigationController?.navigationBar.bounds
        bounds?.size.height += 20
        bounds?.origin.y -= 20
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = bounds!
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if visualEffectView.isDescendant(of: (navigationController?.navigationBar)!) {
            print("Avoiding adding another layer of visualEffectView")
        } else {
            navigationController?.navigationBar.addSubview(visualEffectView)
        }
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        visualEffectView.layer.zPosition = -1
        
        // Removing the seperators between the cells to ensure smooth visuals
        tableViewNews.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Adding a 'pull to refresh' for our tableview
        self.tableViewNews.addSubview(self.refreshControl)
        
        // Setup Anonymous Login Authentication on firebase
        Auth.auth().signInAnonymously() { (user, error) in
        
        // Setting up Firebase
        var ref: DatabaseReference!
        ref = Database.database().reference().child("news");
        
        // Observing the data changes on our Firebase Database
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.newsList.removeAll()
                
                // Iterating through all the values
                for news in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let newsObject = news.value as? [String: AnyObject]
                    let id  = news.key
                    let title  = newsObject!["title"]
                    let description  = newsObject?["description"]
                    let pubDate = newsObject?["pubDate"]
                    //let author = newsObject?["author"]
                    let link = newsObject?["link"]
                    let thumbnail = newsObject?["thumbnail"]
                    
                    //creating news object with model and fetched values
                    let news = NewsModel(title: title as! String?, description: description as! String?, link: link as! String?, thumbnail: thumbnail as! String?, pubDate: pubDate as! String?, id: id as String?)
                    
                    //appending it to list
                    self.newsList.append(news)
                }
                //reloading the tableview
                self.tableViewNews.reloadData()
            }
        })
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
    
        // The news object
        let news: NewsModel
        
        // Getting the article of selected position
        
        // Load from most recent at the top!
        //news = newsList[(newsList.count - indexPath.row - 1)]
        
        // Load as per default
        news = newsList[indexPath.row]
        
        // Adding values to labels
        if (news.title == "Image of the Day") {
            cell.title.text = news.description
        } else {
        cell.title.text = news.title
        }
        
        cell.thumbnail.contentMode = .scaleAspectFill
        
        // In case we've run out of api requests and we fail to get an image returned or there's a slow network.
        cell.thumbnail.image = #imageLiteral(resourceName: "defaultImage")

        // Setting up the title formatting
        cell.title.textAlignment = NSTextAlignment.left
        cell.title.contentInset = UIEdgeInsetsMake(cell.title.frame.size.height - 5, 0, 0, 0)
        
        if ( news.thumbnail == nil ) {
            //print ("No thumbnail available, requesting a random one from unsplash.")
            //randomUnsplash(query: "star+background", imageView: cell.thumbnail)
            print("No thumbnail available, requesting one from google using our title")
            //let formattedSearchTerm = news.title?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            //searchGoogle(searchTerm: formattedSearchTerm!, imageView: cell.thumbnail)
            randomUnsplash(query: "nasa", imageView: cell.thumbnail, id: news.id!)
            //randomUnsplash(query: "nasa", imageView: cell.thumbnail)
            
        } else {
            
            // load image from url
            print ("Thumbnail Available, loading from supplied url.")
            let url = URL(string: news.thumbnail!)
            // Downloads the image asynchronously if it's not cached yet
            cell.thumbnail.kf.setImage(with: url)
        }
        //returning cell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newsList.count
    }
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //reloading the tableview
        self.tableViewNews.reloadData()
        refreshControl.endRefreshing()
    }
    
    func randomUnsplash(query: String, imageView: UIImageView, id: String) -> Void {
        
        // Load a random image from unsplash using their API
        let unsplashClientId = GlobalConstants.unsplashClientId
        let urlPath: String = "https://api.unsplash.com/photos/random/?client_id=\(unsplashClientId)&per_page=1&query=\(query)"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        request1.httpMethod = "GET"
        let queue:OperationQueue = OperationQueue()
        
        // [NSURLSession dataTaskWithRequest:completionHandler:]
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("ASynchronous\(jsonResult)")
                    let json = JSON(data!)
                    if let imageUrl = json["urls"]["medium"].string {
                        // load image from url
                        print("Searching Unsplash...")
                        let url = URL(string: imageUrl)
                    
                        // Saving to firebase so we can give Unsplash a break
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        // Warning : Do not use setValue(), it will overwrite existing data in the database. Use updateChildValues() instead
                        ref.child("news").child(id).updateChildValues(["thumbnail": imageUrl])
                        print("Uploaded Unsplash Link to Firebase")
                        
                        // Downloads the image asynchronously if it's not cached yet
                        imageView.kf.setImage(with: url)
                        
                    } else {
                        // Print the error
                        print(json["urls"]["small"].error!)
                        print("Unsplash API Rate Limit Exceeded Most Likely")
                    }
                    
                    // Obtaining the authors name
                    if let authorName = json["user"]["name"].string {
                        print("Retrieving authors name...")
                        
                        // Saving to firebase so we can give Unsplash a break
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        // Warning : Do not use setValue(), it will overwrite existing data in the database. Use updateChildValues() instead
                        ref.child("news").child(id).updateChildValues(["unsplashAuthor": authorName])
                        print("Uploaded Unsplash Author Name to Firebase")
                        
                    } else {
                        // Print the error
                        print(json["user"]["name"].error!)
                        print("Unsplash API Rate Limit Exceeded Most Likely")
                    }
                    
                    // Obtaining the authors unsplash url
                    if let unsplashUrl = json["user"]["links"]["html"].string {
                        print("Retrieving unsplash authors url...")
                        
                        // Saving to firebase so we can give Unsplash a break
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        // Warning : Do not use setValue(), it will overwrite existing data in the database. Use updateChildValues() instead
                        ref.child("news").child(id).updateChildValues(["unsplashUrl": unsplashUrl])
                        print("Uploaded Unsplash Author URL to Firebase")
                        
                    } else {
                        // Print the error
                        print(json["user"]["name"].error!)
                        print("Unsplash API Rate Limit Exceeded Most Likely")
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
    }
    
    func searchGoogle(searchTerm : String, imageView : UIImageView) -> Void {
        print(searchTerm)
        
        let customSearchEngineKey = GlobalConstants.customSearchEngineKey
        let publicApiKey = GlobalConstants.publicApiKey
        
        //let urlPath: String = "https://www.googleapis.com/customsearch/v1?q=\(searchTerm)&cx=\(customSearchEngineKey)&key=\(publicApiKey)&num=1&imgType=photo&imgSize:12mp&imgColorType=color&alt=json"
        let urlPath: String = "https://www.googleapis.com/customsearch/v1?q=\(searchTerm)&cx=\(customSearchEngineKey)&key=\(publicApiKey)&num=1&searchType=image&imgType=photo&imgSize:12mp&imgColorType=color&alt=json"
        //let url = NSURL(string: urlPath)!
        let url = URL(string: urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url!)
        print(request1)
        
        request1.httpMethod = "GET"
        let queue:OperationQueue = OperationQueue()
        
        // [NSURLSession dataTaskWithRequest:completionHandler:]
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("ASynchronous\(jsonResult)")
                    let json = JSON(data!)
                    print(json)
                    
                    if let imageUrl = json["items"].string {
                        // load image from url
                        print(imageUrl)
                        //let url = URL(string: imageUrl)
                        // Downloads the image asynchronously if it's not cached yet
                        imageView.kf.setImage(with: url)
                        print("Searching Google...")
                    } else {
                        // Print the error
                        print(json["items"]["link"].error!)
                        //self.randomUnsplash(query: "nasa", imageView: imageView)
                        print("Json Error from Google, switching to unsplash as our backup...")
                        
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
        
    }
}
