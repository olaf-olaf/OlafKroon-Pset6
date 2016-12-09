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
    @IBOutlet weak var bookDescription: UITextView!
    
    var data = [String: Any]()
    
    var segueTitle = String()
    
   
    override func viewDidLoad() {
        print("SEGUED", segueTitle)
        bookTitle.text = segueTitle
        super.viewDidLoad()
        getJson(title: segueTitle)
        
        // If the button is clicked get a json from the title the user has given.
                // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson(title: String) {
        
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
                //print(json.value(forKey: "items"))
                
                let items = json.value(forKey: "items") as! NSArray
                
                let book = items[0] as! NSDictionary
                //print("BOOK",book.value(forKey: "volumeInfo"))
                
                let bookDetails = book.value(forKey: "volumeInfo") as! NSDictionary
                
                print("BOOKDETAILS", bookDetails.value(forKey: "authors"))

                
                
               
                
                // Put the json into a dictionary.
                //self.data = json as! [String : String]
               // print("_________DATA_________",self.data)

                
//                if self.data["Response"] == "False" {
//                    print("BOOK NOT FOUND")
//                }
                
            }
         task.resume()
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


