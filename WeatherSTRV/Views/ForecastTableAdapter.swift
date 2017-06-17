//
//  ForecastTableAdapter.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/16/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ForecastTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    weak var delegate:UIViewController?
    
    var tableView:UITableView!
    var previousScrollViewYOffset: CGFloat = 0

    var loadingMoreView:UIView!
    
    var loadingTextMessage = "Loading \n Please Wait"
    var loadingImageMessage = "adapter_loading_icon"
    var emptyTextMessage = "No Content"
   // var emptyImageMessage: UImage? = nil//UIImage(named: "logo_red")
    let cellReuseIdentifier = "ForecastTableViewCell"

    var forecastList: [WeatherModel] = []
    
    open var isFetched: Bool = false {
        didSet {
            //            self.reloadEmptyData()
        }
    }
    
    func didFinishFetching() -> Bool {
        return self.isFetched
    }
    
    public init(tableView:UITableView, delegate:UIViewController) {
        super.init()
        
        self.tableView = tableView
        self.delegate = delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView!.emptyDataSetSource = self
        self.tableView!.emptyDataSetDelegate = self
        
        let cellNib = UINib(nibName: cellReuseIdentifier, bundle: Bundle.main)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)

    }
    
    func reloadTableWith(forecastList: [WeatherModel]){
        DispatchQueue.main.async {
            self.forecastList = forecastList
            self.tableView.reloadData()
           // self.tableView.reloadEmptyDataSet()
        }
    }
    
    //MARK: UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! ForecastTableViewCell
        
        let forecast = forecastList[indexPath.row]
        cell.cellOwner = forecast
        
        return cell
    }
    
    // MARK: - DZNEmptyDataSetDelegate
    
    func reloadEmptyData() {
        DispatchQueue.main.async {
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -50
        
    }
    //    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    //        if !self.didFinishFetching() {
    //            let image = nil
    //            image.withRenderingMode(.automatic)
    //            return image
    //
    //        }
    //        else {
    //            let image = emptyImageMessage
    //            image?.withRenderingMode(.automatic)
    //            return image
    //
    //        }
    //    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if !self.didFinishFetching() {
            let attributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 13)!, NSForegroundColorAttributeName: UIColor.yellow]
            
            return NSAttributedString.init(string: loadingTextMessage, attributes: attributes)
        } else {
            let attributes = [NSFontAttributeName:  UIFont(name: "HelveticaNeue", size: 13)!, NSForegroundColorAttributeName: UIColor.green]
            
            return NSAttributedString.init(string: emptyTextMessage, attributes: attributes)
        }
    }
}
