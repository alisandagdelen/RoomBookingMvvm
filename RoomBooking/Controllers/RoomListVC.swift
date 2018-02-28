//
//  ViewController.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class RoomListVC: UIViewController {
    
    @IBOutlet weak var tblRooms: UITableView!

    private let rowHeight:CGFloat = 120
    private var dataSource: TableViewDataSource<TCellRoom, Room>!
    
    var roomListViewModel: RoomListViewModelProtocol?
    var navigationTitleButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        tblRooms.delegate = self
        tblRooms.register(UINib(nibName: TCellRoom.nibName, bundle: nil), forCellReuseIdentifier: TCellRoom.nibName)
        roomListViewModel = RoomListViewModel()
        fillUI()
        // Do any additional setup after loading the view, typically from a nib.
        }
    
    func fillUI() {
        
        guard let roomListViewModel = roomListViewModel else { return }
        roomListViewModel.rooms.bind { [unowned self] rooms in
            self.dataSource = TableViewDataSource<TCellRoom, Room>(cellIdentifier: TCellRoom.nibName, items: rooms) { (cell, room) in
                cell.lblName.text = room.name
                cell.lblSize.text = room.size
                cell.lblCapacity.text = "\(room.capacity)"
                cell.lblLocation.text = room.location
            }
            self.tblRooms.dataSource = self.dataSource
            self.tblRooms.reloadData()
        }
        
        roomListViewModel.selectedDate.bind { [unowned self] in
            self.navigationTitleButton.setTitle($0.callender, for: .normal)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowNext"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(actNextDay(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(actPreviousDay(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationTitleButton =  UIButton(type: .custom)
        navigationTitleButton.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        navigationTitleButton.setTitleColor(UIColor.black, for: .normal)
        navigationTitleButton.setTitle(roomListViewModel?.selectedDate.value.callender, for: .normal)
        navigationTitleButton.addTarget(self, action: #selector(self.actTitleButton(_:)), for: .touchUpInside)
        self.navigationItem.titleView = navigationTitleButton
    }
    
    func showRoomDetailPopup(room: Room) {
        let roomDetailVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: RoomDetailsVC.self)) as! RoomDetailsVC
        roomDetailVC.roomDetailsViewModel = RoomDetailsViewModel(room: room)
        self.addChildViewController(roomDetailVC)
        roomDetailVC.view.frame = self.view.frame
        self.view.addSubview(roomDetailVC.view)
        roomDetailVC.didMove(toParentViewController: self)
    }
    
    func presentBookRoomVC() {
        
    }
    
    @objc func dateChanged(_ sender:UIDatePicker) {
        
    }
    
    @objc func actPreviousDay(_ sender : UIButton) {
        guard let selectedDate = roomListViewModel?.selectedDate.value else { return }
        guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) else { return }
        roomListViewModel?.changeDate(previousDay)
    }

    @objc func actNextDay(_ sender : UIButton) {
        guard let selectedDate = roomListViewModel?.selectedDate.value else { return }
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) else { return }
        roomListViewModel?.changeDate(nextDay)
    }
    
    @objc func actTitleButton(_ sender: UIButton) {
        // todo
//        let picker: UIDatePicker = UIDatePicker()
//        picker.datePickerMode = .date
//        picker.backgroundColor = UIColor.gray
//        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//        picker.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.frame.size.width, height: 300)
//        self.view.addSubview(picker)
        
    }
}

extension RoomListVC: UITableViewDelegate, RoomDetailsVCDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblRooms.deselectRow(at: indexPath, animated: false)
        guard let selectedRoom = roomListViewModel?.rooms.value[indexPath.row] else { return }
        showRoomDetailPopup(room: selectedRoom)
    }
    
    func bookRoom(_ room: Room) {
        
    }
}


