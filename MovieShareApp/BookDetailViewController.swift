//
//  BookDetailViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 09/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookTextView: UITextView!
    
    var data = [String: Any]()
    var segueTitle = String()
    var bookData = [String]()
  
    override func viewDidLoad() {
        
        print("SEGUED", segueTitle)
        //bookTextView.text = "IN VIEWDIDLOAD"
        //bookTitle.text = segueTitle
//        bookData = getJson(title: segueTitle)
//        if bookData.isEmpty {
//            print("EMPTYDATA")
//        }
//        getUser(title: segueTitle, completionHandler: (NSDictionary?, NSError?) -> ())
        getJson(title: segueTitle)
     
        
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("DOWNLOADING")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
              self.bookCover.image = UIImage(data: data)
           }
        }
    }

    
    
    
 
    
    func getJson(title: String) {
        
        var coverUrl = String()
        
        let filler = title.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let searchRequest = "https://www.googleapis.com/books/v1/volumes?q="+filler+"&maxResults=1&projection=lite&key=AIzaSyB-ad_p9CzeTM138KEXCkHIwhRhOZe5tlg"
        
        let url = URL(string: searchRequest)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            print(json)
          
            let items = json.value(forKey: "items") as! NSArray
            
            let book = items[0] as! NSDictionary
            
            
            let bookDetails = book.value(forKey: "volumeInfo") as! NSDictionary
        
            
            let bookImages = bookDetails.value(forKey: "imageLinks") as! NSDictionary
            let bookCover = bookImages.value(forKey: "thumbnail") as! String
            
            let bookAuthor = bookDetails.value(forKey: "authors") as! NSArray
            let finalAuthor = bookAuthor[0] as! String
            
            let bookDescription = bookDetails.value(forKey: "description")
            let finalDescription = bookDescription! as! String
            
            let titleBook = bookDetails.value(forKey: "title") as! String
            let finalTitle = titleBook
            let coverUrl = URL(string: "http://dummyimage.com")
            
            print("TITLE", titleBook)
            print("AUTHOR", finalAuthor)
            print("DESCRIPTION", finalDescription)
            print("IMAGELINK", bookCover)
            
            //self.downloadImage(url: coverUrl!)
            
    
            
            // Download task:
            // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
            let secondTask = URLSession.shared.dataTask(with: coverUrl!) { (responseData, responseUrl, error) -> Void in
                // if responseData is not null...
                if let data = responseData{
                    print("DATA IS NOT NULL")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.bookCover.image = UIImage(data: data)
                    })
                } else {
                    print ("DATA IS EMPTY")
                }
            }
        
            
        
            
            DispatchQueue.main.sync() {
                self.author.text = finalAuthor
                self.bookTitle.text = finalTitle
                self.bookTextView.text = finalDescription
                // place code for main thread here
            
            }
           
         secondTask.resume()   
        }
        
        task.resume()
    }
}



    func downloadImage(url: URL) {
        print("Download Started")
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            //DispatchQueue.main.async() { () -> Void in
                //bookCover.image = UIImage(data: data)
            
            //self.bookCover.image = UIImage(data: data)

            //}
    }
}







    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


