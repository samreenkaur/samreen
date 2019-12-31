//
//  LeaveStatusViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Parchment

class LeaveStatusViewController: BaseViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- Variables
    //    let pagingViewController = PagingViewController()
    var childViewControllersArray = [UIViewController]()
    var childViewTitleArray = [String]()
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.initializeViewControllers()
        self.addPagingViewController()
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Leave Status"
    }
    
    private func initializeViewControllers()
    {
        self.childViewTitleArray = ["Pending","Approved", "Unapproved","Cancelled" ]
        let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: kLeaveStatusTableViewController) as! LeaveStatusTableViewController
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: kLeaveStatusTableViewController) as! LeaveStatusTableViewController
        let thirdViewController = self.storyboard?.instantiateViewController(withIdentifier: kLeaveStatusTableViewController) as! LeaveStatusTableViewController
        let fourthViewController = self.storyboard?.instantiateViewController(withIdentifier: kLeaveStatusTableViewController) as! LeaveStatusTableViewController
        firstViewController.status = 1
        secondViewController.status = 2
        thirdViewController.status = 3
        fourthViewController.status = 4
        self.childViewControllersArray = [
            firstViewController,
            secondViewController,
            thirdViewController,
            fourthViewController
        ]
    }
    private func addPagingViewController()
    {
        let pagingViewController = FixedPagingViewController(viewControllers: self.childViewControllersArray)
        pagingViewController.menuBackgroundColor = Colors.themeColor
        pagingViewController.indicatorColor = UIColor.white
        pagingViewController.selectedTextColor = UIColor.white
        pagingViewController.textColor = UIColor.white
        
        pagingViewController.dataSource = self
        pagingViewController.select(index: 0)
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    
}
extension LeaveStatusViewController: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
        return self.childViewControllersArray[index]//ItemViewController(index: index)
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        return PagingIndexItem(index: index, title: "\(self.childViewTitleArray[index])") as! T
    }
    
    
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int {
        return self.childViewControllersArray.count
    }
    
    
    
}
