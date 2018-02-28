//
//  BookRoomVC.swift
//  RoomBooking
//
//  Created by alisandagdelen on 28.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit
import PhoneNumberKit

class BookRoomVC: UIViewController {
    
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
        setupTableView()
        fillUI()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tblAttendees.register(UINib(nibName: TCellAttendee.nibName, bundle: nil), forCellReuseIdentifier: TCellAttendee.nibName)
        tblAttendees.delegate = self
        self.tblAttendees.dataSource = self
    }
    
    func fillUI() {
        
        guard let bookRoomViewModel = bookRoomViewModel else { return }
        bookRoomViewModel.attendees.bind { [unowned self] attendees in
            self.tblAttendees.reloadData()
        }
        
        bookRoomViewModel.invalidAttendeeFields.bind { [unowned self] in
            print($0)
            if $0.count == 0 {
                self.txtAttendeeName.text = ""
                self.txtAttendeeEmail.text = ""
                self.txtAttendeePhone.text = ""
            } else {
                let alertMessages = $0.map({$0.rawValue })
                print(alertMessages)
                self.showAlert(title: "Invalid Attendee Field(s)", message: alertMessages.joined(separator: ", "))
            }
        }
        
        bookRoomViewModel.invalidBookingFields.bind { [unowned self] in
            if $0.count != 0 {
                let alertMessages = $0.map({$0.rawValue })
                print(alertMessages)
                self.showAlert(title: "Invalid Booking Field(s)", message: alertMessages.joined(separator: ", "))
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

                self.showAlert(title: "Success", message: "Booking Complete")
            } else {
                self.showAlert(title: "Failed", message: "Booking Failed")
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
