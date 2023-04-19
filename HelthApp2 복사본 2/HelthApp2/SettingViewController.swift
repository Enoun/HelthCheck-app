//
//  SettingViewController.swift
//  HelthApp2
//
//  Created by 김성호 on 2023/04/15.
//

import UIKit
import FSCalendar

class SettingViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weekCalendarView: FSCalendar!
    var date: String?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var doitTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekCalendarView.scope = .week   // 주간
        viewSetup()
        calendarViewSet()
        backView.layer.cornerRadius = 15

    }
    
    func calendar(_ calendar: FSCalendar?, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // week 크기에 따른 프레임 크기 조정
        calendar?.frame = CGRect(origin: calendar?.frame.origin ?? CGPoint.zero, size: bounds.size)
        // 다른 업데이트 작업 수행
        // FSCalendar의 scope를 .week로 설정하여 공백 제거
        calendar?.setScope(.week, animated: true)
 
    }
    
    //MARK: 네비게이션 바 위쪽도 색깔 칠해지게
    func viewSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
    }
    
    
    func calendarViewSet(){
        weekCalendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        weekCalendarView.appearance.headerTitleAlignment = .left
        // calendar locale > 한국으로 설정
        weekCalendarView.locale = Locale(identifier: "ko_KR")
        weekCalendarView.headerHeight = 50
        weekCalendarView.appearance.headerDateFormat = "YYYY년 M월 "  //헤더 년 월 형식 설정
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0  //양 옆 글자 투명도
        weekCalendarView.appearance.headerTitleColor = .black
        weekCalendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)
        // 달력의 요일 글자 바꾸는 방법 2
        weekCalendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        weekCalendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        weekCalendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        weekCalendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        weekCalendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        weekCalendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        weekCalendarView.calendarWeekdayView.weekdayLabels[6].text = "토"
        // 달에 유효하지않은 날짜 지우기
        weekCalendarView.placeholderType = .none
        // 년월에 흐릿하게 보이는 애들 없애기
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0
        
        weekCalendarView.appearance.weekdayTextColor = UIColor.black
        weekCalendarView.appearance.headerTitleColor = UIColor.black
        
        //        calendar.appearance.eventColor = UIColor.green
        //        weekCalendarView.appearance.selectionColor = UIColor.mainColor
        weekCalendarView.appearance.todayColor = .clear
        weekCalendarView.appearance.titleTodayColor = .black
        weekCalendarView.appearance.todaySelectionColor = UIColor.systemBlue
        
        // 특정 날짜에 색깔 칠하기
        weekCalendarView.appearance.eventDefaultColor = .green // 이벤트의 기본 색깔 설정
        weekCalendarView.appearance.eventSelectionColor = .red // 이벤트 선택 시 색깔 설정
        // 특정 날짜에 이벤트가 있는 경우, 해당 날짜에 대한 색깔 설정
        weekCalendarView.dataSource = self
        weekCalendarView.delegate = self
    }
    
    
    
}
