//
//  ViewController.swift
//  LocalNotification
//
//  Created by admin on 20/12/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate{

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timerSetLabel: UILabel!
    @IBOutlet weak var cancelSetLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    //History list
    var historyList: [String] = []
    
    let timerPicker = ["5 minutes", "10 minutes", "20 minutes", "30 minutes"]
    let onlyNumbers = [5,10,20,30]
    
    var timerInterval: TimeInterval = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        //new start
        totalTimeLabel.text = "Total Time: 0"
        timerSetLabel.isHidden = true
        cancelSetLabel.isHidden = true
        workUntilLabel.isHidden = true
        timePicker.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    //Picker Time Section
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timerPicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: timerPicker[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       timerInterval = TimeInterval(onlyNumbers[row])
    }
    
    //Action buttons Section
    
    //Cancel Button
    @IBAction func cancelAction(_ sender: UIButton) {
        //alert
        let alertVC = UIAlertController.init(title: "Cancel current timer?", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Back", style: .cancel, handler: nil))
        
        let action = UIAlertAction.init(title: "Cancel", style: .destructive){
            action in
            self.totalTimeLabel.text = "Total time: 0"
            self.timerSetLabel.text = "0 hours, 0 min"
            self.cancelSetLabel.text = "\(Int(self.timerInterval)) Minute Timer Cancelled"
            self.workUntilLabel.isHidden = true
            
            self.historyList.append("\(Int(self.timerInterval)) Minute Timer Cancelled")
            self.timePicker.isHidden = false
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    //History Button
    @IBAction func historyListAction(_ sender: UIButton) {
        totalTimeLabel.text = "Total Time: \(Int(timerInterval))"
        timerSetLabel.text = "0 hours, \(Int(timerInterval)) min"
        cancelSetLabel.isHidden = false
        workUntilLabel.isHidden = true
        timePicker.isHidden = true
        
        let string = historyList.joined(separator: "\n")
        cancelSetLabel.text = string
    }
    //New Day Button
    @IBAction func newDayAction(_ sender: UIButton) {
        
        //alert
        let alertVC = UIAlertController.init(title: "Are you sure it is a new day?", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        let action = UIAlertAction.init(title: "New Day", style: .destructive){
            action in
            self.totalTimeLabel.text = "Total Time: 0"
            self.timerSetLabel.isHidden = true
            self.cancelSetLabel.isHidden = true
            self.workUntilLabel.isHidden = true
            self.timePicker.isHidden = false
            
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    //Start Timer Button
    @IBAction func startTimerAction(_ sender: UIButton) {
        //alert
        let alertVC = UIAlertController.init(title: "\(Int(timerInterval)) min Countdown",
                                             message: "After \(Int(timerInterval)), you will be notified\n turn you ringer on", preferredStyle: .alert)
       
        let action = UIAlertAction.init(title: "New Day", style: .destructive){
            action in self.startTimerFun()
            
            //update the values
            let minutes: TimeInterval = self.timerInterval * 60
            let cuttentTime = Date()
            let newTime = Date() + minutes
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            let date = dateFormatter.string(from: newTime)
            let current = dateFormatter.string(from: cuttentTime)
                    
            self.workUntilLabel.isHidden = false
            self.cancelSetLabel.isHidden = false
            self.timerSetLabel.isHidden = false
            self.timePicker.isHidden = false
            self.workUntilLabel.text = "Work until: \(date)"
            self.cancelSetLabel.text = "\(Int(self.timerInterval)) Minute Timer Set"
            self.totalTimeLabel.text = "Total time: \(Int(self.timerInterval))"
            self.timerSetLabel.text = "0 hours, \(Int(self.timerInterval)) min"
            let statement = "\(current) - \(date) \(Int(self.timerInterval)) Minute Timer"
            self.historyList.append(statement)
            
        
            
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    //function Section
    func startTimerFun(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        content.sound = UNNotificationSound.default
                
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerInterval) * 60, repeats: false)
                
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
                
        center.add(request) {
            (error : Error?) in
          if let theError = error {
            print(theError.localizedDescription)
           }
        }
    }
}

