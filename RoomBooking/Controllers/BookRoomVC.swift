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
    
    @IBOutlet weak var viewTimeBar: UIView!
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
        
        btnAddAttendee.backgroundColor = UIColor.oneaPurple
        btnBookRoom.backgroundColor = UIColor.oneaDarkGreen
        viewTableBorder.backgroundColor = UIColor.oneaPink
        
        let viewTimeBarGesture = UITapGestureRecognizer(target: self, action:  #selector(self.chooseTime(_:)))
        viewTimeBar.addGestureRecognizer(viewTimeBarGesture)
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
    
    @objc func chooseTime(_ sender : UITapGestureRecognizer) {
        let selectTimeVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: SelectTimeVC.self)) as! SelectTimeVC
        selectTimeVC.availableHours = bookRoomViewModel?.availableHours
        self.addChildViewController(selectTimeVC)
        selectTimeVC.view.frame = self.view.frame
        self.view.addSubview(selectTimeVC.view)
        selectTimeVC.didMove(toParentViewController: self)
    }
    
    @IBAction func actBtnAddAttendee(_ sender: UIButton) {
        guard let name = txtAttendeeName.text, let email = txtAttendeeEmail.text, let phoneNo = txtAttendeePhone.text else { return }
        bookRoomViewModel?.addAttendee(name: name, email: email, phoneNo: phoneNo)
    }
    
    @IBAction func actBookRoom(_ sender: UIButton) {
        guard let title = txtBookingTitle.text, let description = txtViewBookingDesc.text else { return }
        AlertView.show()
        bookRoomViewModel?.bookRoom(title: title, description: description, { [unowned self] (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
                AlertView.show(.success, "Booking Complete")
            } else {
                AlertView.show(.error, title: "Failed", subTitle: "Booking Failed", showCloseButton: true, duration: 0)
            }
        })
    }
}

extension BookRoomVC:UITableViewDelegate, UITableViewDataSource {
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
}
