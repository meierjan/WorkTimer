//
//  DateTableViewController.swift
//  WorkTimer
//
//  Created by Jan Meier on 26.03.15.
//  Copyright (c) 2015 Jan Meier. All rights reserved.
//
import UIKit
import EventKitUI
import Foundation

class DateTableViewController: UITableViewController {

    let model : CalendarModel = CalendarModel(name: "Arbeit")
    var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent,
            completion: {(granted: Bool, error:NSError!) in
                if !granted {
                    println("Access to store not granted")
                }
        })
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadEventData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // method to be called from UIRefreshControl
    func reloadEventData() {
        model.reloadEvents()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return model.weekSpan
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let (_, e) = model.eventWeekByArrayIndex(section)
        return  e?.count ?? 0;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! UITableViewCell
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
        let wochenStunden = model.workedHourByArrayIndex(section)
        return wochenStunden > 0  ? String(format:"%.1f Stunden",wochenStunden) : ""

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Helper Methods
    private func sectionIdToWeekNumber(let sectionId: Int) -> Int {
        return sectionId + 0
    }


}
