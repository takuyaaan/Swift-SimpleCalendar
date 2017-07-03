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
        formatter.dateFormat = "yyyy.MM.dd"
        let displak = formatter.string(from: currentDate)
        titleLabel.text = displak
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.7).cgColor

        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: currentDate)
        textView.text = RealmManager().memoAt(date: dateString)
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
        let alert = UIAlertController(title: "Comfirm", message: "May I delete?", preferredStyle: .alert)
        let actionHandler = { (action: UIAlertAction) in
            self.delegate?.viewWillDismissAtDelete(self)
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: self.currentDate)
            RealmManager().deleteDate(date: dateString)
            self.dismiss(animated: true, completion: nil)
            return
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
        return
    }

    @IBAction func actionSave(_ sender: UIButton) {
        let string = textView.text
        guard (string?.characters.count)! > 0 else {
            let alert = UIAlertController(title: "Comfirm", message: "Not yet entered.", preferredStyle: .alert)
            let actionHandler = { (action: UIAlertAction) in
                self.delegate?.viewWillDismiss(self)
                self.dismiss(animated: true, completion: nil)
                return
            }
            let action = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
            alert.addAction(action)
            let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
            return
        }
        delegate?.viewWillDismissAtSave(self)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: currentDate)
        RealmManager().insertDate(date: dateString, memo: string!)
        dismiss(animated: true, completion: nil)
    }
}
