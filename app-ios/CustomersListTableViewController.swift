//
//  CustomersListTableViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CWStatusBarNotification
import MCSwipeTableViewCell
import DZNEmptyDataSet

class CustomersListTableViewController: UITableViewController, MCSwipeTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UINavigationBarDelegate {
    
    var navigationBar = UINavigationBar()
    
    var customersArray:Array<Customer>?
    
    var viewRefreshControl = UIRefreshControl()
    
    var dateFormatter = NSDateFormatter()
    
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupNav()
        addInfiniteScroll()
    }
    
    private func addInfiniteScroll() {
        // Add infinite scroll handler
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            if self.customersArray!.count > 0 {
                let lastIndex = NSIndexPath(forRow: self.customersArray!.count - 1, inSection: 0)
                let id = self.customersArray![lastIndex.row].id
                // fetch more data with the id
                self.loadCustomerList("100", starting_after: id)
            }
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    private func configureView() {
        
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        let _ = Timeout(1.2) {
            activityIndicator.stopAnimating()
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.viewRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.viewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.viewRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(viewRefreshControl)
        
        self.loadCustomerList("100", starting_after: "")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        // trick to make table lines disappear
        self.tableView.tableFooterView = UIView()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        // let screenHeight = screen.size.height
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.oceanBlue()
        headerView.frame = CGRect(x: 0, y: 10, width: screenWidth, height: 60)
        self.tableView.tableHeaderView = headerView
        let headerViewTitle: UILabel = UILabel()
        headerViewTitle.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 35)
        headerViewTitle.text = "Subscribers"
        headerViewTitle.font = UIFont(name: "SFUIText-Regular", size: 17)!
        headerViewTitle.textAlignment = .Center
        headerViewTitle.textColor = UIColor.whiteColor()
        headerView.addSubview(headerViewTitle)
        
        self.tableView.separatorColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        
    }
    
    private func setupNav() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60)
        navigationBar.backgroundColor = UIColor.clearColor()
        // this changes color of buttons
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconCloseLight"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func loadCustomerList(limit: String, starting_after: String) {
        Customer.getCustomerList(limit, starting_after: starting_after, completionHandler: { (customers, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load customers \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.customersArray = customers
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.viewRefreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.viewRefreshControl.refreshing {
                self.viewRefreshControl.endRefreshing()
            }
            self.tableView?.reloadData()
            
        })
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    func refresh(sender:AnyObject) {
        self.loadCustomerList("100", starting_after: "")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customersArray?.count ?? 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewCustomerDetail" {
            guard let email = customersArray![self.selectedRow!].email else {
                return
            }
            let id = customersArray![self.selectedRow!].id

            let destination = segue.destinationViewController as! CustomersListDetailViewController
            destination.customerId = id
            destination.customerEmail = email
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedRow = indexPath.row
        performSegueWithIdentifier("viewCustomerDetail", sender: self)
    }
    
    // MARK DELEGATE MCTABLEVIEWCELL
    
    func viewWithImageName(name: String) -> UIView {
        let image: UIImage = UIImage(named: name)!;
        let imageView: UIImageView = UIImageView(image: image);
        imageView.contentMode = UIViewContentMode.Center;
        return imageView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "cell";
        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MCSwipeTableViewCell!;
        
        cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
        cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell!.contentView.backgroundColor = UIColor.whiteColor()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        cell.tag = indexPath.row

        let item = self.customersArray?[indexPath.row]
        if let email = item?.email {
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.frame = CGRect(x: 0, y: 0, width: self.view.layer.frame.width, height: 50)
            
            let strEmail = adjustAttributedString(email, spacing: 0, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)

            cell.textLabel?.attributedText = strEmail
        }
        
        let closeView: UIView = self.viewWithImageName("IconCloseLight");
        
        cell.setSwipeGestureWithView(closeView, color:  UIColor.brandRed(), mode: .Exit, state: .State3) {
            (cell : MCSwipeTableViewCell!, state : MCSwipeTableViewCellState!, mode : MCSwipeTableViewCellMode!) in
            let item = self.customersArray?[cell.tag]
            if let id = item?.id {
                print("Did swipe" + id);
                let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                    // send request to delete the bank account, on completion reload table data!
                    Customer.deleteCustomer(id, completionHandler: { (bool, err) in
                        print("deleted customer ", bool)
                        self.loadCustomerList("100", starting_after: "")
                    })
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        };
        
        return cell;
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
}

extension CustomersListTableViewController {
    // Delegate: DZNEmptyDataSet
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Subscribers"
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No subscribers to show"
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmpty")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Create a subscription plan to get started"
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RecurringBillingViewController") as! RecurringBillingViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}
