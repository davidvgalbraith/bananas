//
//  EventCollectionViewController.swift
//  social-events
//
//  Created by David Galbraith on 8/2/15.
//  Copyright (c) 2015 David Galbraith. All rights reserved.
//

import UIKit

class EventCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private let reuseIdentifier = "EventCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var events = [EventModel]()
    private var selectedEvent:EventModel!
    
    override func viewDidLoad() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)

        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        let filePath = NSBundle.mainBundle().pathForResource("events",ofType:"json")
        DataManager.getDataFromFileWithSuccess(filePath, success: { (data) -> Void in
            let json = JSON(data: data)
            if let events = json["events"].array {
                self.events.removeAll(keepCapacity: false)
                for event in events {
                    var e = EventModel(name: event["name"].string, event_description: event["event_description"].string);
                    self.events.append(e);
                }
            } else {
                println("Event parsing failed")
                println(json)
                assert(false)
            }
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        let event = events[indexPath.item]
        
        cell.eventNameLabel.text = event.name
        cell.descriptionLabel.text = event.event_description

        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var bounds = UIScreen.mainScreen().bounds
            return CGSizeMake(bounds.width, 100)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let event = events[indexPath.item]
]        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("EventDetailsViewController") as! EventDetailsViewController
        vc.event_title_text = event.name
        vc.event_description_text = event.event_description
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
