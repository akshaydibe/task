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
    let dataTableview = UITableView()
    
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
        view.addSubview(dataTableview)
        dataTableview.addSubview(self.refreshControl)
        dataTableview.translatesAutoresizingMaskIntoConstraints = false
        dataTableview.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        dataTableview.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        dataTableview.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        dataTableview.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        dataTableview.estimatedRowHeight = 100
        dataTableview.rowHeight = UITableView.automaticDimension
        dataTableview.allowsSelection = false
        self.view.backgroundColor = UIColor.red
        
        dataTableview.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if #available(iOS 11.0, *) {
            dataTableview.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            dataTableview.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            dataTableview.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            dataTableview.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        setUpNavigation()
         callWebservice()
        
    }
    
    func setUpNavigation() {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 204/255, green: 47/255, blue: 40/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont]
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: - Networking
    fileprivate func callWebservice(){
        if reachability.connection != .unavailable{
            self.activityIndicatorStart()
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
                DispatchQueue.main.async {
                    self.dataViewModel.rows = self.dataViewModel.rows.filter { (model) -> Bool in
                        return (model.title != nil || model.description != nil || model.imageHref != nil)
                    }

                    self.dataTableview.delegate = self
                    self.dataTableview.dataSource = self
                    self.dataTableview.reloadData()
                    self.navigationItem.title = self.dataViewModel.title

                }

            }

        }else{
            self.activityIndicatorStop()
            self.showErrorAlert(message: "No Internet Connection.Please try again later.")
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

        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        if let title = self.dataViewModel.rows[indexPath.row].title {
            Cell.titleLabel.text = title
        }else {
            Cell.titleLabel.text = "NA"

        }
        

        if let description = self.dataViewModel.rows[indexPath.row].description {
            Cell.descLabel.text = description
        }else {
            Cell.descLabel.text = ""
        }
        


        if let image = self.dataViewModel.rows[indexPath.row].imageHref {
            let newImage = image.replacingOccurrences(of: "http", with: "https")
            Cell.profileImageView.sd_setImage(with: URL(string: newImage), placeholderImage: UIImage(named: "placeholder.png"))

        }else {
            Cell.profileImageView.image = UIImage.init(named: "placeholder.png")
        }

        return Cell

    }


}
