//
//  ViewController.swift
//  FSCalendarExample
//
//  Created by uno on 2020/10/27.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var calendar: FSCalendar!
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var datesWithEvent = ["2020-10-25", "2020-10-26", "2020-10-27", "2020-10-28"]
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCalendar()
    }

}

// MARK:- Configure UI
extension ViewController {
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        // 여러날짜를 동시에 선택할 수 있도록
        calendar.allowsMultipleSelection = true
        
        // 스와이프
        calendar.swipeToChooseGesture.isEnabled = true
        
        // 달력 구분 선 제거
        calendar.clipsToBounds = false
        
        // 헤더 포맷 커스터마이징
        calendar.appearance.headerDateFormat = "yyyy.MM"
        
        // 한글
        calendar.locale = Locale(identifier: "ko")
        
        // appearance
//        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20.0)
//        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 4)
//        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 10)
        
        calendar.appearance.weekdayTextColor = UIColor.red
        calendar.appearance.headerTitleColor = UIColor.orange
        calendar.appearance.eventDefaultColor = .yellow
        calendar.appearance.eventSelectionColor = .green
        calendar.appearance.selectionColor = UIColor.blue
        calendar.appearance.todayColor = UIColor.gray
        calendar.appearance.todaySelectionColor = UIColor.black
        
        // cell border - 기본값은 원, 0으로 설정시 사각형
//        calendar.appearance.borderRadius = 0

    }
    
}

// MARK:- Methods
extension ViewController {
    
}


// MARK:- FS Calendar DataSource
extension ViewController: FSCalendarDataSource {
    
    // 특정 날짜 보다 작은 날짜 선택 불가능
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        // 현재날짜
//        return Date()
//    }
    
    // 사용 가능한 날짜 범위에서 날짜 선택
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return Date().addingTimeInterval((24*60*60)*7)
//    }
    
    // 특정 날짜 점 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return 0 }
        
        if date.compare(eventDate) == .orderedSame {
            return 2
        }
        
        return 0
    }
    
}

// MARK:- FS Calendar Delegate
extension ViewController: FSCalendarDelegate {
    
    // 특정 날짜 선택시 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택")
        print(dateFormatter.string(from: date))
    }
    
    // 특정 날짜 선택 해제시 이벤트
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택 해제")
        print(dateFormatter.string(from: date))
    }
    
    // 스와이프를 통해서 다른 달(month)의 달력으로 넘어갈 때 발생하는 이벤트를 이 곳에서 처리할 수 있겠네요.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("페이지 넘김")
    }
    
    
    // 특정 날짜를 선택되지 않게 할 수 있다.
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let excludeDate = dateFormatter.date(from: "2020-10-28") else { return true }
        
        if date.compare(excludeDate) == .orderedSame {
            return false
        } else {
            return true
        }
    }

}

// MARK:- FS Calendar Delegate Appearance
extension ViewController: FSCalendarDelegateAppearance {
    
    // 특정 날짜 색 바꾸기
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return nil }
        
        if date.compare(eventDate) == .orderedSame {
            return .red
        } else {
            return nil
        }
    }
}
