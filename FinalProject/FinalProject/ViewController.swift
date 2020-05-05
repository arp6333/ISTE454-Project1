//
//  ViewController.swift
//  FinalProject
//
//  Created by Ellie on 4/25/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit
import KDCalendar

class ViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var newEventTextField: UITextField!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func addEvent(_ sender: Any) {
        newEventTextField.resignFirstResponder()
        if newEventTextField!.text != nil && newEventTextField!.text != "" {
            let event = CalendarEvent(title: newEventTextField!.text!, startDate: datePicker.date, endDate: datePicker.date)
            print("Adding event...")
            writeData(event: event)
        }
    }
    @IBAction func deleteAll(_ sender: Any) {
        let url = URL(fileURLWithPath: plistPath)
        do {
            let data = try Data(contentsOf: url)
            var tempDict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[String: Any]]
            // Remove all events
            for event: CalendarEvent in selectedEvents {
                allEvents.remove(at: allEvents.firstIndex(where: {$0.startDate.description == event.startDate.description})!)
                tempDict.remove(at: tempDict.firstIndex(where: {($0["date"]! as! Date).description == event.startDate.description})!)
            }
            let writeData = try PropertyListSerialization.data(fromPropertyList: tempDict, format: .xml, options:0)
            try writeData.write(to: url)
            print("Data successfully removed")
            selectedEvents.removeAll()
            setEvents()
        } catch {
            print(error)
        }
    }
    
    var selectedDate = Date()
    var allEvents: [CalendarEvent] = []
    var selectedEvents: [CalendarEvent] = [CalendarEvent(title: "Event", startDate: Date(), endDate: Date())]
    var plistPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Round corners for looking nice
        newButton.layer.cornerRadius = 10
        newButton.clipsToBounds = true
        calendarView.layer.cornerRadius = 10
        calendarView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
        newEventTextField.delegate = self
        
        let style = CalendarView.Style()
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray
        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
        style.headerBackgroundColor    = UIColor.white
        style.weekdaysBackgroundColor  = UIColor.white
        style.firstWeekday             = .sunday
        style.locale                   = Locale(identifier: "en_US")
        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        calendarView.style = style
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        calendarView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
    
        // Get all events
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            allEvents = delegate.events
            plistPath = delegate.plistPath
        }
        
        setEvents()
    }
    
    func setEvents() {
        // Clear text view and events
        textView.text = ""
        selectedEvents.removeAll()
        // Get selected dates events
        let str = selectedDate.description
        let start = str.index(str.startIndex, offsetBy: 0)
        let end = str.index(str.endIndex, offsetBy: -14)
        let range = start..<end
        let dateText = str[range]
        print("Looking for: " + dateText)
        for event: CalendarEvent in allEvents {
            if event.startDate.description[range] == dateText {
                selectedEvents.append(event)
                let dfTime = DateFormatter()
                dfTime.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
                dfTime.dateFormat = "h:mm a"
                dfTime.amSymbol = "AM"
                dfTime.pmSymbol = "PM"
                let time = dfTime.string(from: event.startDate)
                textView.text += time + " - " + event.title + "\n"
           }
        }
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        print("Go Previous")
        calendarView.goToPreviousMonth()
    }
    
    @IBAction func goToNextMonth(_ sender: Any) {
        print("Go Next")
        calendarView.goToNextMonth()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func headerString(_ date: Date) -> String? {
        // Get the month and year from the Date
        let str = date.description
        var start = str.index(str.startIndex, offsetBy: 0)
        var end = str.index(str.endIndex, offsetBy: -21)
        var range = start..<end
        let year = str[range]
        start = str.index(str.startIndex, offsetBy: 5)
        end = str.index(str.endIndex, offsetBy: -18)
        range = start..<end
        let month = str[range]
        // Convert number month into string month
        let monthName = DateFormatter().monthSymbols?[Int(month)! - 1]
        return monthName! + " " + year
    }
    
    func startDate() -> Date {
        // Start 200 years ago
        var dateComponents = DateComponents()
        dateComponents.month = -2400
        let today = Date()
        let startDate = calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return startDate
    }

    func endDate() -> Date {
        // End in 200 years
        var dateComponents = DateComponents()
        dateComponents.month = 2400
        let today = Date()
        let endDate = calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return endDate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Select todays date to start
        let today = Date()
        calendarView.setDisplayDate(today, animated: false)
        datePicker.locale = calendarView.style.locale
        datePicker.timeZone = calendarView.calendar.timeZone
        datePicker.setDate(today, animated: false)
    }
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        print("DatePicker Did Select: \(picker.date)")
        let str = selectedDate.description
        let start = str.index(str.startIndex, offsetBy: 0)
        let end = str.index(str.endIndex, offsetBy: -14)
        let range = start..<end
        let dateText = str[range]
        print("Picker:" + picker.date.description[range])
        print("Calendar:" + dateText)
        if picker.date.description[range] != dateText {
            calendarView.selectDate(picker.date)
        }
        selectedDate = picker.date
        setEvents()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newEventTextField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newEventTextField.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print(calendarView.selectedDates)
        datePicker.setDate(date, animated: true)
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        print(calendarView.selectedDates)
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        print("Calendar Did Select: \(date)")
        selectedDate = date
        datePicker.setDate(date, animated: true)
        // Get all events for selected date
        setEvents()
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
        // Do nothing right now
    }
    
    func writeData(event: CalendarEvent) {
        let url = URL(fileURLWithPath: plistPath)
        do {
            let data = try Data(contentsOf: url)
            var tempDict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[String: Any]]
            tempDict.append(["title": event.title, "date": event.startDate])
            let writeData = try PropertyListSerialization.data(fromPropertyList: tempDict, format: .xml, options:0)
            try writeData.write(to: url)
            print("New Data: " + event.title + ", " + event.startDate.description)
            print("Data written successfully to " + url.absoluteString)
            selectedEvents.append(event)
            allEvents.append(event)
            setEvents()
        } catch {
            print(error)
        }
    }
}
