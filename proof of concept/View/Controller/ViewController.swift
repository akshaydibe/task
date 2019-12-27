//
//  ViewController.swift
//  proof of concept
//
//  Created by Amit Dhadse on 10/12/19.
//  Copyright © 2019 Akshay Dibe. All rights reserved.
//

import UIKit
import SDWebImage
import Reachability

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let dataViewModel = viewModel(dataService: DataService())
    let reachability = try! Reachability()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(self.refreshControl)
        callWebservice()

    }
    
    // MARK: - Networking
    fileprivate func callWebservice(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        dataViewModel.callWebservice()
        dataViewModel.updateLoadingStatus = {
            let _ = self.dataViewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        dataViewModel.showAlertClosure = {
            if let error = self.dataViewModel.error {
                print(error.localizedDescription)
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
        
        dataViewModel.didFinishFetch = {

        }
        refreshControl.endRefreshing()
    }
    
    // MARK: - Refresh Control Event
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        callWebservice()
    }


}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataViewModel.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let imageView = Cell.viewWithTag(1) as! UIImageView
        let titleLabel = Cell.viewWithTag(2) as! UILabel
        let descriptionLabel = Cell.viewWithTag(3) as! UILabel

        if let title = self.dataViewModel.rows[indexPath.row].title {
            titleLabel.text = title
        }else {
            titleLabel.text = "NA"

        }
        

        if let description = self.dataViewModel.rows[indexPath.row].description {
            descriptionLabel.text = description
        }else {
            descriptionLabel.text = "NA"
        }
        


        if let image = self.dataViewModel.rows[indexPath.row].imageHref {
            DataService.sharedInstance.downloadImages(image: image) { (downloadedImage) in
                imageView.image = downloadedImage
            }
        }else {
            imageView.image = UIImage.init(named: "placeholder.png")
        }

        return Cell

    }


}
