//
//  DateViewController.swift
//  WorkTimer
//
//  Created by Jan Meier on 23.06.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//

import UIKit
import EventKitUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    let model : CalendarModel = CalendarModel(name: "NextBike")
    var eventStore = EKEventStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore.requestAccessToEntityType(EKEntityTypeEvent,
            completion: {(granted: Bool, error:NSError!) in
                if !granted {
                    println("Access to store not granted")
                }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reloadEventData:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func reloadEventData() {
        //model.reloadEvents()
        self.tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.weekSpan
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (_, e) = model.eventWeekByArrayIndex(section)
        return  e?.count ?? 0;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DataCell") as! UITableViewCell
        let (_,parentItem) = model.eventWeekByArrayIndex(indexPath.section)
        let  item = parentItem![indexPath.row]
        cell.textLabel?.text =  item.title
        cell.detailTextLabel?.text = item.notes ?? ""
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (woche, _ ) = model.eventWeekByArrayIndex(section)
        return "Woche \(woche)"
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let wochenStunden = model.getWorkedhoursForIndex(section)
        let ueberStunden = model.getOverhoursForIndex(section)
        let ueberStundenBis = model.getOverhoursUntilWeek(section)
        return String(format:
                "%.1f Stunden \n"
            +   "%.1f Überstunden diese Woche \n"
            +   "%.1f Überstunden total"
            , wochenStunden, ueberStunden, ueberStundenBis)
        
    }

    private func sectionIdToWeekNumber(let sectionId: Int) -> Int {
        return sectionId + 0
    }
    
}