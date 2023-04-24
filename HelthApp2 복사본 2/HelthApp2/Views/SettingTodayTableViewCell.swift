//
//  SettingTodayTableViewCell.swift
//  HelthApp2
//
//  Created by 김성호 on 2023/04/19.
//

import UIKit
import RealmSwift



class SettingTodayTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // 오늘 할 운동을 고르는 필드
    @IBOutlet weak var pickerField: UITextField!
    
    // picker에서 보여줄 값들
    let pickerValues = ["등", "가슴", "어깨", "하체", "복근", "팔", "유산소"]
    // 선택된 값을 저장할 변수
    var selectedValue: String?
    var indexPath: IndexPath?
    var selectedDate: Date?
    
    // Add dateString property
    var dateString: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerField.delegate = self
        pickerField.layer.cornerRadius = 15
        
        createPickerView()

        // Realm에서 값을 가져와서 텍스트 필드에 설정
        let realm = try! Realm()

        // realm에 데이터베이스가 비어있다면, 새로운 데이터를 만들어 realm에 작성한다.
        if realm.objects(SettingData.self).isEmpty {
            let newSettingData = SettingData()
            try! realm.write {
                realm.add(newSettingData)
                print("Stored values in Realm:", newSettingData.values)
            }
        }

        //셀에서 선택한 날짜 또는 선택한 날짜가 설정되지 않은 경우 현재 날짜 사용
        let dateToUse = selectedDate ?? Date()

        
        if let indexPath = indexPath, let dateString = dateString {
            let exercise = realm.objects(Exercise.self).filter("date = %@ AND order = %d", dateString, indexPath.row).first
            pickerField.text = exercise?.name
        }
    }
        //선택창(PickerView) 설정코드
        func createPickerView() {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerField.inputView = pickerView
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
            toolbar.setItems([flexibleSpace, doneButton], animated: true)
            pickerField.inputAccessoryView = toolbar
            doneButton.tintColor = .black
        }
        
        // pickerView 안에 있는 Done버튼을 눌렀을 때 실행
        @objc func doneButtonTapped() {
            print("Done button tapped")
                if let value = selectedValue, let indexPath = indexPath {
                    //realm에 데이터를 저장
                    let realm = try! Realm()
                    
                    let settingViewController = self.window?.rootViewController as? SettingViewController
                    // Use the selected date from the cell or the current date if the selected date is not set
                    let dateToUse = selectedDate ?? Date()
                    let currentDate = getDate(for: dateToUse)

                    if let existingExercise = realm.objects(Exercise.self).filter("date = %@ AND order = %d", currentDate, indexPath.row).first {
                        try! realm.write {
                            existingExercise.name = value
                        }
                    } else {
                        let newExercise = Exercise()
                        newExercise.name = value
                        newExercise.date = currentDate
                        newExercise.order = indexPath.row

                        try! realm.write {
                            realm.add(newExercise)
                        }
                    }

                    pickerField.text = value
                }
                pickerField.resignFirstResponder()
            }

        //날짜를 받아오는 코드
        func getDate(for date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        
        //MARK: UIPickerViewDelegate, UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerValues.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerValues[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedValue = pickerValues[row]
        }
    }
