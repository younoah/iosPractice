//
//  CalendarViewController.swift
//  FSCalendarExample
//
//  Created by uno on 2020/11/01.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {


    @IBOutlet weak var calendar: FSCalendar!

    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date]?
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let highlightedColorForRange = UIColor.init(red: 2/255, green: 138/255, blue: 75/238, alpha: 0.2)


    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.allowsMultipleSelection = true
        calendar.clipsToBounds = true
    }
}

extension CalendarViewController {

    func configureVisibleCells() {
        self.calendar.visibleCells().forEach { (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }

    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        // Configure selection layer
        if position == .current {

            var selectionType = SelectionType.none

            if calendar.selectedDates.contains(date!) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date!)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date!)!
                if calendar.selectedDates.contains(date!) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        diyCell.selectionLayer!.fillColor = highlightedColorForRange.cgColor
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date!) {
                        selectionType = .single // .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .single // .leftBorder
                    }
                    else {
                        selectionType = .middle //.single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer!.isHidden = true
                return
            }
            diyCell.selectionLayer!.isHidden = false
            diyCell.selectionType = selectionType

        } else {
            diyCell.selectionLayer!.isHidden = true
        }
    }

    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
             configureVisibleCells()
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")
                configureVisibleCells()
                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")
            configureVisibleCells()
            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
        configureVisibleCells()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureCell(cell, for: date, at: monthPosition)
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == FSCalendarMonthPosition.current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(self.formatter.string(from: date))")
        configureVisibleCells()
    }

}
