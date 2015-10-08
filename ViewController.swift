//
//  DateViewController.swift
//  WorkTimer
//
//  Created by Jan Meier on 23.06.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//

import UIKit
import EventKitUI


class ViewController: UITableViewController
{

    private let model : CalendarModel = CalendarModel(name: "NextBike")
    private var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: requestEventstoreCallback)
        self.setNavbarStyle()
    }
    
    func requestEventstoreCallback(granted: Bool, error:NSError?){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshTableViewContent"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.weekSpan
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (_, e) = model.eventWeekByArrayIndex(section)
        return  e?.count ?? 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DataCell")!
        let (_,parentItem) = model.eventWeekByArrayIndex(indexPath.section)
        let  item = parentItem![indexPath.row]
        cell.textLabel?.text =  item.title
        cell.detailTextLabel?.text = item.notes ?? ""
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (woche, _ ) = model.eventWeekByArrayIndex(section)
        return "Woche \(woche)"
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let wochenStunden = model.getWorkedhoursForIndex(section)
        let ueberStunden = model.getOverhoursForIndex(section)
        let ueberStundenBis = model.getOverhoursUntilWeek(section)
        return String(format:
                "%.1f Stunden \n"
            +   "%.1f Überstunden diese Woche \n"
            +   "%.1f Überstunden total"
            , wochenStunden, ueberStunden, ueberStundenBis)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let indexPath = sender?.indexPath
        if let segueName = sender?.identifier {
            switch segueName {
                case "showDateDetail"?:
                    let destinationViewController = segue.destinationViewController as! DateDetailViewController
                    let (_,parentItem) = model.eventWeekByArrayIndex(indexPath!.section)
                    let  item = parentItem![indexPath!.row]
                    destinationViewController.setEventForDate(item)
            default:
                NSLog("Segue nicht gefunden")
            }
        }
        
    }

    // MARK: public functions
    func refreshTableViewContent() {
        self.model.reloadEvents()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: private helper functions
    private func sectionIdToWeekNumber(let sectionId: Int) -> Int {
        return sectionId + 0
    }
    
    private func setNavbarStyle() {
        if let nav = self.navigationController?.navigationBar {
            nav.barTintColor = UIColor(red: 67/255, green: 49/255, blue: 117/255, alpha:1)
        }
    }
    
}