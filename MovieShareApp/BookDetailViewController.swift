//
//  BookDetailViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 09/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//
// BookdetailViewControllor.swift gets a json from the google books api and presents 
// data in a viewControllor.

import UIKit
import Firebase

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookTextView: UITextView!
    
    //Store a title from the previous view.
    var segueTitle = String()
  
    override func viewDidLoad() {
        
        //Get all data for a given title.
        getJson(title: segueTitle)
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func getJson(title: String) {
        
        // Create a url to connect to the google books api with the given title.
        let filler = title.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let searchRequest = "https://www.googleapis.com/books/v1/volumes?q="+filler+"&maxResults=1&projection=lite&key=AIzaSyB-ad_p9CzeTM138KEXCkHIwhRhOZe5tlg"
        let url = URL(string: searchRequest)
        
        // Get data from the google books API.
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
             // Get values from json.
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            print(json)
            
            let itemscount = json.value(forKey: "totalItems") as! Int
            

            // Only get data if the given title is in the google books database.
            if itemscount != 0 {
          
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
                let coverUrl = URL(string: bookCover)
            
                // Download Image
                let task = URLSession.shared.dataTask(with: coverUrl!) { (responseData, responseUrl, error) -> Void in
                    if let data = responseData{
                        print("DATA IS NOT NULL")
                    
                        DispatchQueue.main.async(execute: { () -> Void in
                        
                            //Present image in view
                            self.bookCover.image = UIImage(data: data)
                        })
                    } else {
                        print ("DATA IS EMPTY")
                    }
                }
                task.resume()
            
        
                // Present data in view.
                DispatchQueue.main.sync() {
                    self.author.text = finalAuthor
                    self.bookTitle.text = finalTitle
                    self.bookTextView.text = finalDescription
            
                }
            }
            
        }
        task.resume()
    }
}



