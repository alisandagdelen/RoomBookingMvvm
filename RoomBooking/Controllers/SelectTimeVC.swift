//
//  SelectTimeVC.swift
//  RoomBooking
//
//  Created by Dagdelen, Alisan(AWF) on 3/1/18.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit
// MARK: Shity Code, Shity Class :(

protocol SelectTimeVCDelegate:class {
    func timeSelected(beginTime: String, endTime:String)
}
class SelectTimeVC: BasePopupVC {
    
    @IBOutlet weak var pickerHourRange: UISlider!
    @IBOutlet weak var pickerBeginTime: UISlider!
    @IBOutlet weak var pickerDuration: UISlider!
    @IBOutlet weak var viewAvailableHours: UIView!
    @IBOutlet weak var viewBeginTime: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewLabelPositionRange: UIView!
    @IBOutlet weak var viewLabelPositionBegin: UIView!
    weak var delegate:SelectTimeVCDelegate?
    
    var availableHours:[String]!
    var selectedRange:String?
    var selectedBeginTime:String?
    var timeDiffrence:Int?
    
    var beginHourLabels:[UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedRange = availableHours[0]
        showAnimate()
        setColors()
        setupPickers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAvailableHoursView()
        setupBeginTimeView()
    }
    func setupPickers() {
        setupRangePicker()
        setupBeginTimePicker()
        setupDurationTimePicker()
    }
    
    func setupRangePicker() {
        pickerHourRange.value = 1
        pickerHourRange.minimumValue = 1
        pickerHourRange.maximumValue = Float(availableHours.count)
    }
    
    func setupAvailableHoursView() {
        let spaceWidth = pickerHourRange.frame.size.width / CGFloat(availableHours.count - 1)
        var xPosition = pickerHourRange.frame.origin.x - 15
        let yPosition = viewLabelPositionRange.frame.origin.y
        for i in 1...availableHours.count {
            let label = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: 70, height: 20))
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.text = availableHours[i - 1]
            viewAvailableHours.addSubview(label)
            xPosition += spaceWidth
        }
    }
    
    func setupBeginTimePicker() {
        guard let beginHour = selectedRange?.hoursTuple.begin.hourIntTuple.hour else { return }
        guard let beginMinute = selectedRange?.hoursTuple.begin.hourIntTuple.minute else { return }
        
        guard let endHour = selectedRange?.hoursTuple.end.hourIntTuple.hour else { return }
        guard let endMinute = selectedRange?.hoursTuple.end.hourIntTuple.minute else { return }
        timeDiffrence = ((endHour - beginHour) * 60) + endMinute - beginMinute
        
        pickerBeginTime.value = 1
        pickerBeginTime.minimumValue = 1
        pickerBeginTime.maximumValue = Float(timeDiffrence!/15)
        setupBeginTimeView()
        setupDurationTimePicker()
    }
    
    func setupDurationTimePicker() {
        guard let selectedBeginHour = selectedBeginTime?.hourIntTuple.hour else { return }
        guard let selectedBeginMinute = selectedBeginTime?.hourIntTuple.minute else { return }
        
        guard let endHour = selectedRange?.hoursTuple.end.hourIntTuple.hour else { return }
        guard let endMinute = selectedRange?.hoursTuple.end.hourIntTuple.minute else { return }
        
        let minuteRange = (endHour - selectedBeginHour) * 60 + endMinute - selectedBeginMinute
        
        pickerDuration.value = 1
        pickerDuration.minimumValue = 1
        pickerDuration.maximumValue = Float(minuteRange/15)
    }
    
    func setupBeginTimeView(){
        guard let timeDiffrence = timeDiffrence else { return }
        guard let beginHour = selectedRange?.hoursTuple.begin.hourIntTuple.hour else { return }
        guard let beginMinute = selectedRange?.hoursTuple.begin.hourIntTuple.minute else { return }
        let optionCount = timeDiffrence/15
        
        let spaceWidth = viewLabelPositionBegin.frame.size.width / CGFloat(optionCount-1)
        var xPosition = viewLabelPositionBegin.frame.origin.x
        let yPosition = viewLabelPositionBegin.frame.origin.y
        beginHourLabels.forEach({$0.removeFromSuperview()})
        beginHourLabels = []
        for i in 1...optionCount {
            let totalMinute = ((i - 1) * 15) + beginMinute + (beginHour * 60)
            let label = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: 25, height: 20))
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.text = timeStringFromMinute(totalMinute: totalMinute)
            viewBeginTime.addSubview(label)
            beginHourLabels.append(label)
            xPosition += spaceWidth
        }
        
    }
    
    func timeStringFromMinute(totalMinute:Int) -> String {
        let hour:Int = totalMinute / 60
        let minute = totalMinute % 60
        let hourString = hour - 10 < 0 ? "0\(hour)" : "\(hour)"
        let minuteString = minute - 10 < 0 ? "0\(minute)" : "\(minute)"
        return "\(hourString):\(minuteString)"
    }
    
    
    func setColors() {
        pickerHourRange.minimumTrackTintColor = UIColor.oneadarkBlue
        pickerHourRange.thumbTintColor = UIColor.oneadarkBlue
        pickerHourRange.maximumTrackTintColor = UIColor.oneadarkBlue
        
        pickerBeginTime.minimumTrackTintColor = UIColor.oneaPurple
        pickerBeginTime.thumbTintColor = UIColor.oneaPurple
        pickerBeginTime.maximumTrackTintColor = UIColor.oneaPurple
        
        pickerDuration.minimumTrackTintColor = UIColor.oneaPink
        pickerDuration.thumbTintColor = UIColor.oneaPink
        pickerDuration.maximumTrackTintColor = UIColor.oneaPink
        
        btnDone.backgroundColor = UIColor.oneaGreen
    }
    
    
    @IBAction func actDoneBtn(_ sender: UIButton) {
        if let selectedBookingTime = availableHours.first {
            let beginTime = selectedBookingTime.hoursTuple.begin
            let endTime = selectedBookingTime.hoursTuple.end
            delegate?.timeSelected(beginTime: beginTime, endTime:endTime)
        }
        removeAnimate()
    }
    
    @IBAction func hourRangeChanged(_ sender: UISlider) {
        pickerHourRange.value = roundf(pickerHourRange.value)
        
        if selectedRange != availableHours[Int(pickerHourRange.value) - 1] {
            selectedRange = availableHours[Int(pickerHourRange.value) - 1]
            setupBeginTimePicker()
        }
        
    }
    @IBAction func beginHourChanged(_ sender: UISlider) {
        pickerBeginTime.value = roundf(pickerBeginTime.value)
        let beginTime = (pickerBeginTime.value - 1) * 15
        guard let beginHour = selectedRange?.hoursTuple.begin.hourIntTuple.hour else { return }
        guard let beginMinute = selectedRange?.hoursTuple.begin.hourIntTuple.minute else { return }
        let newBeginTime = timeStringFromMinute(totalMinute: (beginHour * 60) + beginMinute + Int(beginTime))
        if selectedBeginTime !=  newBeginTime {
            selectedBeginTime = newBeginTime
            setupDurationTimePicker()
        }
    }
    
    @IBAction func durationChanged(_ sender: UISlider) {
        pickerDuration.value = roundf(pickerDuration.value)
    }
}
