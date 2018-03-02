//
//  ViewController.swift
//  HTML Parse
//
//  Created by Robbie Perry on 2018-02-22.
//  Copyright © 2018 Robbie Perry. All rights reserved.
//

import UIKit
import TraceLog
import Alamofire
import SwiftSoup

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrape("http://reddit.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrape(_ url: String) {
        Alamofire.request(url).responseString { response in
            if let html = response.result.value {
                self.parse(html: html)
            }
        }
    }
    
    func parse(html: String) {
        do {
            var topPosts = ""
            
            //Create Document Element
            let doc: Document = try SwiftSoup.parse(html)
            
            let redditPosts: Elements = try doc.select("div[id^=thing_]")
            let titles: Elements = try redditPosts.select("a[data-event-action=title]")
            
            for title: Element in titles {
                topPosts += try title.html() + "\n\n"
            }
            
            /*let posts = try doc.getElementById("siteTable")?.getChildNodes()
            
            for post in posts! {
                if try !post.attr("id").isEmpty {
                    try topPosts += (post.childNode(4).childNode(0).childNode(0).childNode(0).childNode(0).outerHtml()) + "\n\n"
                }
            }*/
            
            textView.text = topPosts
        } catch Exception.Error(let message) {
            print(message)
            textView.text = "Error Loading Results"
        } catch {
            textView.text = "Error Loading Results"
        }
    }
}

