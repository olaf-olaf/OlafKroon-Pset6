//
//  BookDetailViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 09/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

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
        bookTextView.text = "IN VIEWDIDLOAD"
        //bookTitle.text = segueTitle
         bookData = getJson(title: segueTitle)
        if bookData.isEmpty {
            print("EMPTYDATA")
            
        } else {
            print("THERE IS DATA")
        }
        
        
        
     
        
        for item in bookData{
            print("_______DATA__________")
            print(item)
        }
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson(title: String) -> [String] {
        
            var bookData = [String]()
        
            let filler = title.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            print("FILLER", filler)
            // https://www.googleapis.com/books/v1/volumes?q=de+aanslag&maxResults=1&projection=lite&key=AIzaSyB-ad_p9CzeTM138KEXCkHIwhRhOZe5tlg
            let searchRequest = "https://www.googleapis.com/books/v1/volumes?q="+filler+"&maxResults=1&projection=lite&key=AIzaSyB-ad_p9CzeTM138KEXCkHIwhRhOZe5tlg"
                //"https://www.omdbapi.com/?t="+filler+"y=&plot=short&r=json"
            
            
            // Get a json from an URL source: http://stackoverflow.com/questions/38292793/http-requests-in-swift-3
            let url = URL(string: searchRequest)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard error == nil else {
                    print("error")
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                // Get status code.
                let httpResponse = response as! HTTPURLResponse
                print("STATUSCODE: ", httpResponse.statusCode)
                
                
                // Parse the data into a json.
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
             
                
                let items = json.value(forKey: "items") as! NSArray
                
                let book = items[0] as! NSDictionary
                
                
                let bookDetails = book.value(forKey: "volumeInfo") as! NSDictionary
                
                //print("BOOKDETAILS", bookDetails.value(forKey: "authors"))
                
                //Dive into json file
                
                let bookAuthor = bookDetails.value(forKey: "authors") as! NSArray
                let bookDescription = bookDetails.value(forKey: "description")
                let titleBook = bookDetails.value(forKey: "title") as! String
                let finalAuthor = bookAuthor[0] as! String
                let finalTitle = titleBook
                let finalDescription = bookDescription! as! String
             
                
                print("TITLE", titleBook)
                print("AUTHOR", bookAuthor[0])
                print("DESCRIPTION", bookDescription!)
                
                // Update view
                self.author.text = finalAuthor
                self.bookTitle.text = finalTitle
                bookData.append(finalTitle)
                bookData.append(finalAuthor)
                bookData.append(finalDescription)
                
                
                
//                self.bookDescription.text = bookDescription! as! String

                
                
            }
         task.resume()
         return bookData
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


