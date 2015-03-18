//
//  VerifyInterfaceController.swift
//  Mist
//
//  Created by Jack Cook on 3/18/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import WatchKit

class VerifyInterfaceController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        let context = context as [String: [String]]
        let results = context["results"]!
        
        tableView.setNumberOfRows(results.count, withRowType: "VerifyRow")
        
        for i in 0...tableView.numberOfRows - 1 {
            let row = tableView.rowControllerAtIndex(i) as VerifyRow
            row.locationName.setText(results[i])
        }
    }
}
