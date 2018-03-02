//
//  BookRoomVC.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SCLAlertView

class BookRoomVC: UIViewController {
    
    @IBOutlet weak var lblAvailableHours: UILabel!
    @IBOutlet weak var btnChooseTime: UIButton!
    @IBOutlet weak var btnBookRoom: UIButton!
    @IBOutlet weak var btnAddAttendee: UIButton!
    @IBOutlet weak var viewTableBorder: UIView!
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var tblAttendees: UITableView!
    @IBOutlet weak var txtAttendeeName: UITextField!
    @IBOutlet weak var txtAttendeeEmail: UITextField!
    @IBOutlet weak var txtAttendeePhone: UITextField!
    @IBOutlet weak var txtBookingTitle: UITextField!
    @IBOutlet weak var txtViewBookingDesc: UITextView!
    
    var bookRoomViewModel: BookRoomViewModelProtocol?
    private var dataSource: TableViewDataSource<TCellAttendee, Attendee>!
    let rowHeight:CGFloat = 72
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        tblAttendees.register(UINib(nibName: TCellAttendee.nibName, bundle: nil), forCellReuseIdentifier: TCellAttendee.nibName)
        tblAttendees.delegate = self
        self.tblAttendees.dataSource = self
        addDoneButtonTextfield()
        
        lblAvailableHours.text = bookRoomViewModel?.availableHours.joined(separator: " | ")
        
        lblAvailableHours.textColor = UIColor.oneaDarkGreen
        btnAddAttendee.backgroundColor = UIColor.oneaPurple
        btnBookRoom.backgroundColor = UIColor.oneaDarkGreen
        btnChooseTime.backgroundColor = UIColor.oneaGreen
    }
    
    func fillUI() {
        
        guard let bookRoomViewModel = bookRoomViewModel else { return }
        bookRoomViewModel.attendees.bind { [unowned self] attendees in
            self.tblAttendees.reloadData()
        }
        
        lblRoomName.text = bookRoomViewModel.roomName
        
        bookRoomViewModel.invalidAttendeeFields.bind { [unowned self] in
            print($0)
            if $0.count == 0 {
                self.txtAttendeeName.text = ""
                self.txtAttendeeEmail.text = ""
                self.txtAttendeePhone.text = ""
            } else {
                let alertMessages = $0.map({$0.rawValue }).joined(separator: ", ")
                AlertView.show(.warning, title: "Invalid Attendee Field(s)", subTitle: alertMessages, showCloseButton: true, duration: 0)
            }
        }
        
        bookRoomViewModel.invalidBookingFields.bind {
            if $0.count != 0 {
                let alertMessages = $0.map({$0.rawValue }).joined(separator: ", ")
                print(alertMessages)
                AlertView.show(.warning, title: "Invalid Booking Field(s)", subTitle: alertMessages, showCloseButton: true, duration: 0)
            }
        }
    }
    
    func showChooseTimePopup() {
        let selectTimeVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: SelectTimeVC.self)) as! SelectTimeVC
        selectTimeVC.availableHours = bookRoomViewModel?.availableHours
        selectTimeVC.delegate = self
        self.addChildViewController(selectTimeVC)
        selectTimeVC.view.frame = self.view.frame
        self.view.addSubview(selectTimeVC.view)
        selectTimeVC.didMove(toParentViewController: self)
    }
    
    func addDoneButtonTextfield() {

        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()

        txtAttendeeName.inputAccessoryView = toolbar
        txtBookingTitle.inputAccessoryView = toolbar
        txtAttendeeEmail.inputAccessoryView = toolbar
        txtAttendeePhone.inputAccessoryView = toolbar
        txtViewBookingDesc.inputAccessoryView = toolbar
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func actBtnChooseTime(_ sender: UIButton) {
        showChooseTimePopup()
    }
    
    @IBAction func actBtnAddAttendee(_ sender: UIButton) {
        guard let name = txtAttendeeName.text, let email = txtAttendeeEmail.text, let phoneNo = txtAttendeePhone.text else { return }
        bookRoomViewModel?.addAttendee(name: name, email: email, phoneNo: phoneNo)
    }
    
    @IBAction func actBookRoom(_ sender: UIButton) {
        guard let title = txtBookingTitle.text, let description = txtViewBookingDesc.text else { return }
        bookRoomViewModel?.bookRoom(title: title, description: description, { [unowned self] (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}

extension BookRoomVC:UITableViewDelegate, UITableViewDataSource, SelectTimeVCDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookRoomViewModel?.attendees.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TCellAttendee.nibName, for: indexPath) as! TCellAttendee
        cell.lblName.text = bookRoomViewModel?.attendees.value[indexPath.row].name
        cell.lblEmail.text = bookRoomViewModel?.attendees.value[indexPath.row].email
        cell.lblPhoneNo.text = bookRoomViewModel?.attendees.value[indexPath.row].phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblAttendees.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedAttendee = bookRoomViewModel?.attendees.value[indexPath.row] {
                bookRoomViewModel?.deleteAttendee(selectedAttendee)
            }
        }
    }
    
    func timeSelected(beginTime: String, endTime:String) {
        bookRoomViewModel?.selectBookingTime(timeStart: beginTime, timeEnd: endTime)
    }
    
}
