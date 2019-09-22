//
//  ViewController.swift
//  SMF-Assignment
//
//  Created by Waqas Sultan on 9/20/19.
//  Copyright © 2019 Waqas Sultan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var dataSourceArray:[UInt64]  = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //   self.tableView.reloadData()
        activityIndictor.hidesWhenStopped = true
        calculateSequence()

        // Do any additional setup after loading the view.
    }
    
    func calculateSequence() {
        
        activityIndictor.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let maxValue = UInt64.max
            for value in 0...maxValue {
                self.dataSourceArray.append(self.fib(value))

            }

            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.activityIndictor.stopAnimating()
                self.tableView.reloadData()

            }
        }
        
        
        
    }
    
    
    func fib(_ num: UInt64) -> UInt64 {
        switch num {
        case UInt64.min...1: return max(0, num)
        default: return fib(num-2) + fib(num-1)
        }
    }


}


extension ViewController : UITableViewDelegate,UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "\(dataSourceArray[indexPath.row])"
        return cell
    }
    
}

