//
//  RootViewController.swift
//  IrvaBusSchedule
//
//  Created by Cat on 4/3/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var segmentBtn: UISegmentedControl!
    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet weak var timeTableToIrva: UITableView!
    @IBOutlet weak var timeTableToBeresteiska: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      Timer.scheduledTimer(timeInterval: 2, target: self,  selector: (#selector(toSendRequest)), userInfo: nil, repeats: true)
    }
    
   @objc func toSendRequest() {
        Request.sendRequest(completion: {
        
        self.timeTableToIrva.reloadData()
        self.timeTableToBeresteiska.reloadData()
        })
    }
    
    @IBAction func tapsSegmentButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            myScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            myScroll.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width, y:0), animated: true)

        default:
            break
        }
    }
    
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
             return Storage.shared.scheduleDataFirstScreen.count
        } else {
            return Storage.shared.scheduleDataSecondScreen.count

        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeTableToIrva.dequeueReusableCell(withIdentifier: "theCell", for: indexPath) as! FirstScreenCellToIrva
        if tableView.tag == 1 {
            cell.setData(data: Storage.shared.scheduleDataFirstScreen[indexPath.row])
        }
        if tableView.tag == 2 {
            cell.setData(data: Storage.shared.scheduleDataSecondScreen[indexPath.row])
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch myScroll.contentOffset.x {
        case UIScreen.main.bounds.size.width * 0:
            segmentBtn.selectedSegmentIndex = 0
        case UIScreen.main.bounds.size.width * 1:
            segmentBtn.selectedSegmentIndex = 1
        default:
            break
        }
    }
    
}
