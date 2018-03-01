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
    @IBOutlet weak var viewTop: UIView!
    
    private let rowHeight:CGFloat = 120
    private var dataSource: TableViewDataSource<TCellRoom, Room>!
    
    var filterView:FilterView?
    var roomListViewModel: RoomListViewModelProtocol?
    var navigationTitleButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupUI()
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
    
    func setupUI() {
        tblRooms.delegate = self
        tblRooms.register(UINib(nibName: TCellRoom.nibName, bundle: nil), forCellReuseIdentifier: TCellRoom.nibName)
        filterView = FilterView.fromNib as? FilterView
        let appearPoint:CGFloat = self.viewTop.frame.origin.y + self.viewTop.frame.size.height
        filterView?.frame = CGRect(x: 0, y: appearPoint, width: self.view.frame.size.width, height: 0)
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
        roomDetailVC.delegate = self
        self.addChildViewController(roomDetailVC)
        roomDetailVC.view.frame = self.view.frame
        self.view.addSubview(roomDetailVC.view)
        roomDetailVC.didMove(toParentViewController: self)
    }
    
    func showOrHideFilters() {
        guard let filterView = filterView else { return }
        
        if self.view.subviews.contains(filterView) {
            UIView.animate(withDuration: 0.5, animations: {
                filterView.frame.size.height = 0
            }, completion: { (success) in
                filterView.removeFromSuperview()
            })
        } else {
            self.view.addSubview(filterView)
            UIView.animate(withDuration: 0.5, animations: {
                filterView.frame.size.height = 210
            })
        }
    }
    
    func presentBookRoomVC(_ room:Room) {
        guard let roomListViewModel = roomListViewModel else { return }
        
        let bookRoomVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: BookRoomVC.self)) as! BookRoomVC
        bookRoomVC.bookRoomViewModel = BookRoomViewModel(room: room, date: roomListViewModel.selectedDate.value)
        self.navigationController?.pushViewController(bookRoomVC, animated: true)
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
//
//        let appearPoint:CGFloat = self.viewTop.frame.origin.y + self.viewTop.frame.size.height
//        picker.frame = CGRect(x: 0, y: appearPoint, width: self.view.frame.size.width, height: 0)
//            self.view.addSubview(picker)
//        UIView.animate(withDuration: 1) {
//            picker.frame.size.height = 300
        }
        
        
    }
    @IBAction func actFilterBtn(_ sender: UIButton) {
        showOrHideFilters()
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
        presentBookRoomVC(room)
    }
}


