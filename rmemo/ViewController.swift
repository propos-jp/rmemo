//
//  ViewController.swift
//  rmemo
//
//  Created by obata on 2017/04/14.
//  Copyright © 2017年 obata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    var text:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.textView != nil {
            self.textView.text = self.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setText(text: String) {
        self.text = text
    }
    

}

