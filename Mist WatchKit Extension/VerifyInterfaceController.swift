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
    @IBOutlet var reminderLabel: WKInterfaceLabel!
    
    var results = [String]()
    var autocomplete = [String]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setTitle("Loading...")
        self.results = context as [String]
    }
    
    override func willActivate() {
        super.willActivate()
        
        WKInterfaceController.openParentApplication(["results": results], reply: { (data, error) -> Void in
            println("")
            let autocompleteResults = data as [String: [String]]
            self.autocomplete = autocompleteResults["results"]!
            self.loadAutocomplete()
        })
    }
    
    func loadAutocomplete() {
        self.setTitle("Which one?")
        self.reminderLabel.setHidden(true)
        self.tableView.setNumberOfRows(autocomplete.count, withRowType: "VerifyRow")
        
        for i in 0...tableView.numberOfRows - 1 {
            let row = tableView.rowControllerAtIndex(i) as VerifyRow
            row.locationName.setText(self.autocomplete[i])
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        WKInterfaceController.openParentApplication(["load": autocomplete[rowIndex]], reply: { (data, error) -> Void in
            self.dismissController()
        })
    }
}
