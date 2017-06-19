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
    
    //MARK:- Variables
    weak var delegate:UIViewController?
    var tableView:UITableView!
    var previousScrollViewYOffset: CGFloat = 0
    var loadingMoreView:UIView!
    var loadingTextMessage = "Loading Forecast \n Please Wait"
    var emptyTextMessage = "Currently can't fetch forecast \n Please Try Again Later !!"
    var forecastList: [WeatherModel] = []
    var isFetched: Bool = false
    let cellReuseIdentifier = "ForecastTableViewCell"

    
    //MARK:- init
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
    
    //MARK:- Actions
    func reloadTableWith(forecastList: [WeatherModel]?){
        DispatchQueue.main.async {
            self.isFetched = true
            if let forecastList = forecastList{
                self.forecastList = forecastList
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! ForecastTableViewCell
        let forecast = forecastList[indexPath.row]
        cell.cellOwner = forecast
        return cell
    }
    
    // MARK: - DZNEmptyDataSetDelegate
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -50
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let image = #imageLiteral(resourceName: "AppIcon")
        image.withRenderingMode(.automatic)
        return image
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont(name: "ProximaNova-Semibold", size: 13)!, NSForegroundColorAttributeName: UIColor.black]

        if !isFetched {
            return NSAttributedString.init(string: loadingTextMessage, attributes: attributes)
        } else {
            return NSAttributedString.init(string: emptyTextMessage, attributes: attributes)
        }
    }
}
