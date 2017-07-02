//
//  MemoViewController.swift
//  SimpleCalendar
//
//  Created by Takuyaaan on 2017/06/30.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    var delegate: ViewControllerDelegate!
    fileprivate var currentDate = Date()

    var selectedDate: Date {
        get {
            return self.currentDate
        }
        set(date) {
            self.currentDate = date
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let displak = formatter.string(from: currentDate)
        titleLabel.text = displak
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.7).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        delegate?.viewWillDismiss(self)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionDelete(_ sender: UIButton) {
        delegate?.viewWillDismissAtDelete(self)
        //TODO: delete
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSave(_ sender: UIButton) {
        delegate?.viewWillDismissAtSave(self)
        //TODO: delete
        dismiss(animated: true, completion: nil)
    }
}
