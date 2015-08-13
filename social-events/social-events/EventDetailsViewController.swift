//
//  EventDetailsViewController.swift
//  social-events
//
//  Created by David Galbraith on 8/13/15.
//  Copyright (c) 2015 David Galbraith. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet var event_title: UILabel!
    @IBOutlet var event_description: UITextView!
    
    var event_description_text: String!
    var event_title_text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.event_title.text = self.event_title_text
        self.event_description.text = self.event_description_text
    }
    
    override func viewWillAppear(animated: Bool) {
        self.event_description.scrollRangeToVisible(NSRange(location:0, length:0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
