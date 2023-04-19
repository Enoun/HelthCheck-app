//
//  ViewController.swift
//  HelthApp2
//
//  Created by 김성호 on 2023/04/13.
//

import UIKit
import FSCalendar


class ViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegateAppearance {

   
    @IBOutlet weak var calendarView: FSCalendar!
    let calendar = Calendar.current
    lazy var currentPage = calendarView.currentPage
    lazy var today: Date = {
        return Date()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        calendarView.delegate = self
        calendarViewSet()
        viewSetup()
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        moveMonth(next: false)
        calendarView.reloadData() // 이 부분을 추가해주세요.
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        moveMonth(next: true)
        calendarView.reloadData() // 이 부분을 추가해주세요.
        print("버튼이 눌렸습니다")
    }
    
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage)!
        self.calendarView.setCurrentPage(self.currentPage, animated: true)
    }
    
    func setEvents() {
        let dfMatter = DateFormatter()
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyy-MM-dd"
        
    }
    
    func viewSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        calendarView.backgroundColor = UIColor.secondColor
        self.calendarView.layer.cornerRadius = 15
    }
    
    func calendarViewSet(){
        
        calendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        // calendar locale > 한국으로 설정
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.headerHeight = 50
        calendarView.appearance.headerDateFormat = "M월 YYYY"  //헤더 년 월 형식 설정
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0  //양 옆 글자 투명도
        calendarView.appearance.headerTitleColor = .white
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
        // 달력의 요일 글자 바꾸는 방법 2
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"
        // 달에 유효하지않은 날짜 지우기
        calendarView.placeholderType = .none
        // 년월에 흐릿하게 보이는 애들 없애기
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        
        calendarView.appearance.weekdayTextColor = UIColor.white
        calendarView.appearance.headerTitleColor = UIColor.white
        calendarView.appearance.titleDefaultColor = UIColor.white
        calendarView.appearance.selectionColor = UIColor.mainColor
        calendarView.appearance.todayColor = UIColor.mainColor
        calendarView.appearance.todaySelectionColor = UIColor.mainColor
    }
    
    // 날짜 선택 시 호출되는 delegate 메서드
        func nextCalendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            // 다음 화면으로 넘어가는 코드 작성
            let nextViewController = SettingViewController() // 다음 화면의 뷰 컨트롤러 생성
            self.navigationController?.pushViewController(nextViewController, animated: true) // 다음 화면으로 이동
        }
}

extension UIColor {
    class var mainColor: UIColor? { return UIColor(named: "MainColor")}
    class var secondColor: UIColor? { return UIColor(named: "SecondColor")}
    class var backColor: UIColor? { return UIColor(named: "BackColor")}
}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let nextViewController = self.storyboard?.instantiateViewController(identifier: "SettingViewController") as? SettingViewController else { return }

        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nextViewController.date = dateFormatter.string(from: date)

        // 내비게이션 스택에 다음 화면을 푸시합니다.
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
