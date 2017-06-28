//
//  ViewController.swift
//  SimpleCalendar
//
//  Created by TakuyaMano on 2017/06/28.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let dateManager = CalendarDateManager()
    fileprivate let daysPerWeek: Int = 7
    fileprivate let margin: CGFloat = 2.0
    fileprivate var selectedDate = Date()
    fileprivate var today: NSDate!
    fileprivate let weekly = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCalendarTitle(from: selectedDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCalendarTitle(from date: Date) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.string(from: date)
        calendarTitle.text = selectMonth
    }
    
    @IBAction func touchPrev(_ sender: UIButton) {
        selectedDate = dateManager.prevMonth(date: selectedDate)
        collectionView.reloadData()
        setCalendarTitle(from: selectedDate)
    }
    
    @IBAction func touchNext(_ sender: UIButton) {
        selectedDate = dateManager.nextMonth(date: selectedDate)
        collectionView.reloadData()
        setCalendarTitle(from: selectedDate)
    }
}

extension ViewController: UICollectionViewDelegate {

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return weekly.count
        } else {
            return dateManager.daysCalculation()
        }
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarViewCell
        
        if (indexPath.row % daysPerWeek == 0) {
            cell.dateLabel.textColor = UIColor.red
        } else if (indexPath.row % daysPerWeek == 6) {
            cell.dateLabel.textColor = UIColor.blue
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
        //テキスト配置
        if indexPath.section == 0 {
            cell.dateLabel.text = weekly[indexPath.row]
        } else {
            cell.dateLabel.text = dateManager.conversionFormat(indexPath)
            if !dateManager.isCurrentMonth(indexPath) {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
        return cell
    }
    
    @available(iOS 6.0, *)
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - margin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}
