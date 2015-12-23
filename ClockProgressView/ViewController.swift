//
//  ViewController.swift
//  ClockProgressView
//
//  Created by Adrian Lesniak on 22/12/2015.
//  Copyright © 2015 Adrian Lesniak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockProgressView: ClockProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func toggle(sender: AnyObject) {
        clockProgressView.toggle()
    }
}

