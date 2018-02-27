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
                cell.lblEquipment.text = room.equipments.joined(separator: " ,")
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.plain, target: self, action: #selector(actNextDay(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(actPreviousDay(_:)))
        
        navigationTitleButton =  UIButton(type: .custom)
        navigationTitleButton.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        navigationTitleButton.setTitleColor(UIColor.black, for: .normal)
        navigationTitleButton.setTitle(roomListViewModel?.selectedDate.value.callender, for: .normal)
        navigationTitleButton.addTarget(self, action: #selector(self.actTitleButton(_:)), for: .touchUpInside)
        self.navigationItem.titleView = navigationTitleButton
    }
    
    func showRoomDetailPopup() {
        let roomDetailVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: RoomDetailsVC.self)) as! RoomDetailsVC
        self.addChildViewController(roomDetailVC)
        roomDetailVC.view.frame = self.view.frame
        self.view.addSubview(roomDetailVC.view)
        roomDetailVC.didMove(toParentViewController: self)
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
        print("test")
    }
}

extension RoomListVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblRooms.deselectRow(at: indexPath, animated: false)
        showRoomDetailPopup()
    }
    
}


