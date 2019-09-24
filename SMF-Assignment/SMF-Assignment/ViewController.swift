//
//  ViewController.swift
//  SMF-Assignment
//
//  Created by Waqas Sultan on 9/20/19.
//  Copyright © 2019 Waqas Sultan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var dataSourceArray:[BInt]  = []
    
    var componentDataSourceArray:[[BInt]] = []
   
    var currentIndex = UInt64(0)
    var currentScreen = 0
    var mem = [UInt64: BInt]()
    var totalRows = UInt64.max
    var component:UInt64 = 100000
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //   self.tableView.reloadData()
        activityIndictor.hidesWhenStopped = true
        currentIndex = UInt64(1000)
        calculateSequence(startValue: 0, maxValue: 1000)

        // Do any additional setup after loading the view.
    }
    
    func calculateSequence(startValue:UInt64,maxValue:UInt64) {
        
        activityIndictor.startAnimating()
        
        let concurrentQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".concurrentQueue", qos: .background, attributes: .concurrent)
        
        if self.currentScreen == 0 {
            concurrentQueue.async {
                for value in startValue ..< (maxValue) {
                    
                    let resu = self.fib(value)
                    self.dataSourceArray.append(resu)
                }
                
                DispatchQueue.main.async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.activityIndictor.stopAnimating()
                    self.tableView.reloadData()
                    
                }
            }

        } else {
            var startV = UInt64(0)
            var endV  = UInt64(0)
            let maxV = UInt64.max
            let concurSecondQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".concurrentQueue", qos: .background, attributes: .concurrent)
            
            
            concurSecondQueue.async {
                for index in  stride(from: 100000, to: maxV, by: 100000) {
                    startV = endV
                    endV = endV + UInt64(index)
                    var tempArray:[BInt] = []
                    concurrentQueue.async {
                        for value in startV ..< (endV) {
                            
                            let resu = self.fibonacci(value)
                            tempArray.append(resu)
                        }
                        self.componentDataSourceArray.append(tempArray)
                        DispatchQueue.main.async {
                            if startV >= maxV {
                                self.activityIndictor.stopAnimating()
                            }
                            self.tableView.reloadData()
                            
                        }
                    }
                    
                }
                
                if startV >= maxV {
                    DispatchQueue.main.async {
                        self.activityIndictor.stopAnimating()
                        self.tableView.reloadData()
                        
                    }
                }
                
                
            }
            
            
        }
        
    }
    
    
//    func fib(_ num: UInt64) -> BInt {
//        switch num {
//        case UInt64.min...1: return BInt(max(0, num))
//        default: return fib(num-2) + fib(num-1)
//        }
//    }
    
    func fib (_ num: UInt64) -> BInt {
        if let cached = mem[num] {
            return cached
        }

        let result: BInt

        if (num <= 2) {
            result = BInt(1)
        }
        else {
            result = fib(num - 1) + fib(num - 2 )
        }

        mem[num] = result
        return result
    }
    
    
    func fibonacci (_ num: UInt64) -> BInt {
       
        var a = BInt(0)
        var b = BInt(1)
        for index in  stride(from: 31, to: -1, by: -1) {

            
            let d = a * (b * 2 - a)
            let e  = a * a + b * b
            
            a = d
            b = e
            
            if ((num >> index) & 1) != 0 {
                let c = a + b
                a = b
                b = c
            }
            
        }
        return a
    }

    @IBAction func indexChanged(_ sender: Any) {
        self.dataSourceArray.removeAll()
        self.componentDataSourceArray.removeAll()
        self.tableView.reloadData()
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            currentScreen  = 0
        case 1:
            currentScreen  = 1
            calculateSequence(startValue: 0, maxValue: 0)
        default:
            break
        }
        
    }
    
}


extension ViewController : UITableViewDelegate,UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentScreen == 0 {
            return dataSourceArray.count
        }
        
        return componentDataSourceArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if currentScreen == 0 {
            return 1
        }
        
        return componentDataSourceArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        if currentScreen == 0 {
            cell.textLabel?.text = "f (\(indexPath.row) ) = \(dataSourceArray[indexPath.row])"
        } else {
            cell.textLabel?.text = "f (\(indexPath.row) ) = \(componentDataSourceArray[indexPath.section][indexPath.row])"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentScreen == 0 {
            if (indexPath.row + 1 >= self.currentIndex && self.currentIndex < totalRows) {
                
                self.calculateSequence(startValue: currentIndex, maxValue: currentIndex + 1000)
                currentIndex = currentIndex  + UInt64(1000)
                
            }
        }
    }
    
    
}

