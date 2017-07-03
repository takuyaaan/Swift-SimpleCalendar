//
//  ViewController.swift
//  SimpleCalendar
//
//  Created by Takuyaaan on 2017/06/28.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import UIKit

class SelectedView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.orange.cgColor)
        context.fillEllipse(in: rect)
    }
}

protocol ViewControllerDelegate {
    func viewWillDismiss(_ viewController: UIViewController)
    func viewWillDismissAtSave(_ viewController: UIViewController)
    func viewWillDismissAtDelete(_ viewController: UIViewController)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let dateManager = CalendarDateManager()
    fileprivate let daysPerWeek: Int = NSCalendar.current.shortStandaloneWeekdaySymbols.count
    fileprivate let margin: CGFloat = 2.0
    fileprivate var selectedIndex: IndexPath!
    fileprivate var selectedDate: Date!
    fileprivate var today = Date()
    fileprivate let weekly = NSCalendar.current.shortStandaloneWeekdaySymbols
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCalendarTitle(from: today)
        selectedDate = today
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setCalendarTitle(from date: Date) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy.M"
        let selectMonth = formatter.string(from: date)
        calendarTitle.text = selectMonth
    }

    fileprivate func createSelectedView(_ cell: UICollectionViewCell) {
        var frame = cell.frame
        frame.size.height /= 4
        frame.size.width = frame.size.height
        frame.origin.y = frame.size.height * 3
        frame.origin.x = (cell.frame.size.width - frame.size.width)/2
        
        let selectedView = SelectedView(frame: frame)
        selectedView.backgroundColor = UIColor.clear
        cell.contentView.addSubview(selectedView)
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

extension ViewController: ViewControllerDelegate {

    func viewWillDismissAtSave(_ viewController: UIViewController) {
        collectionView.deselectItem(at: selectedIndex, animated: false)
        let selectedCell = collectionView.cellForItem(at: selectedIndex)
        selectedCell?.backgroundColor = UIColor.clear
        createSelectedView(selectedCell!)
    }

    func viewWillDismissAtDelete(_ viewController: UIViewController) {
        collectionView.deselectItem(at: selectedIndex, animated: false)
        let selectedCell = collectionView.cellForItem(at: selectedIndex)
        selectedCell?.backgroundColor = UIColor.clear
        for subview in (selectedCell?.contentView.subviews)! {
            subview.removeFromSuperview()
        }
    }

    func viewWillDismiss(_ viewController: UIViewController) {
        collectionView.deselectItem(at: selectedIndex, animated: false)
        let selectedCell = collectionView.cellForItem(at: selectedIndex)
        selectedCell?.backgroundColor = UIColor.clear
    }
}

extension ViewController: UICollectionViewDelegate {

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemoViewController")

        let dateString = calendarTitle.text! + "." + (selectedCell as! CalendarViewCell).dateLabel.text!
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.dd"
        selectedDate = formatter.date(from: dateString)!
        (vc as! MemoViewController).selectedDate = selectedDate
        (vc as! MemoViewController).delegate = self

        present(vc, animated: true, completion: nil)
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
        cell.contentView.subviews.forEach{(sub) in
            sub.removeFromSuperview()
        }
        
        if (indexPath.row % daysPerWeek == 0) {
            cell.dateLabel.textColor = UIColor.red
        } else if (indexPath.row % daysPerWeek == 6) {
            cell.dateLabel.textColor = UIColor.blue
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
        if indexPath.section == 0 {
            cell.dateLabel.text = weekly[indexPath.row]
        } else {
            let day = dateManager.conversionFormat(indexPath)
            cell.dateLabel.text = day
            if !dateManager.isCurrentMonth(indexPath) {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = UIColor.lightGray
            }
            else {
                let checkDateString = calendarTitle.text! + "." + day
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = "yyyy.M.d"
                let checkDate = formatter.date(from: checkDateString)!
                formatter.dateFormat = "yyyy-MM-dd"
                if RealmManager().isSaveAt(date: formatter.string(from: checkDate)) {
                    createSelectedView(cell)
                }
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
