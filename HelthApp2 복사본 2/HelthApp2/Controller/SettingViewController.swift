//
//  SettingViewController.swift
//  HelthApp2
//
//  Created by 김성호 on 2023/04/15.
//

import UIKit
import RealmSwift
import MagicTimer

// 데이터 모델 정의
class Exercise: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var order = 0
}

class SettingData: Object {
    let values = List<String>()
}

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var timer: MagicTimerView!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerResetButton: UIButton!
    
    var nameArray: [String] = ["등", "어깨", "하체", "복근", "유산소", "가슴", "팔"]
    var date: String?
    var selectedDate: Date?
    var resetCount = 0
        
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer.startCounting()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetCount += 1
        if resetCount == 1 {
            timer.stopCounting()
        } else if resetCount == 2 {
            timer.reset()
            resetCount = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        settingTableView.dataSource = self
        tableViewSetup()
        timersetup()

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        // Set the date property if it's not set
        if date == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.string(from: Date())
        }
        
    }
    
    //MARK: 네비게이션 바 위쪽도 색깔 칠해지게
    func viewSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func tableViewSetup() {
        settingTableView.layer.cornerRadius = 15
        settingTableView.backgroundColor = .backColor
        backView.layer.cornerRadius = 15
        
        //view를 누르면 키보드 내려감
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //스탑워치
    func timersetup() {
        timer.isActiveInBackground = false
        timer.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        timer.mode = .stopWatch
        
        timer.cornerRadius = 20
        timerButton.layer.cornerRadius = 15
        timerButton.clipsToBounds = true
        timerResetButton.layer.cornerRadius = 15
        timerResetButton.clipsToBounds = true
    }
        
    

    //몇줄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //row에 무슨 셀을 표시할지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTodayTableViewCell

        // Set the indexPath of the cell
        cell.indexPath = indexPath
        
        // Pass the date to the cell
        cell.dateString = date
        
        // Pass the date to the cell
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.selectedDate = dateFormatter.date(from: date)
        }
        
        // Call awakeFromNib to update the cell with the new selectedDate
        cell.awakeFromNib()

        // Pass the selectedDate to the cell
         cell.selectedDate = selectedDate

        // Set the text field's value using the saved exercises for the current date
        let realm = try! Realm()
        
        // Use the selected date or the current date if the selected date is not set
        let dateToUse = selectedDate ?? Date()
        let currentDate = cell.getDate(for: dateToUse)
        
        let exercise = realm.objects(Exercise.self).filter("date = %@ AND order = %d", currentDate, indexPath.row).first

        // Only set the text field's value if there's an exercise saved for this indexPath
        if let exercise = exercise {
            cell.pickerField.text = exercise.name
        }

        return cell
    }
    
    
}
