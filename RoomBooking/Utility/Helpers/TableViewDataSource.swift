//
//  DataSource.swift
//  RoomBooking
//
//  Created by alisandagdelen on 27.02.2018.
//  Copyright © 2018 alisandagdelen. All rights reserved.
//

import UIKit

class TableViewDataSource<CellType: UITableViewCell, Model>: NSObject, UITableViewDataSource {
    
    var cellIdentifier: String!
    var items: [Model]!
    var configureCell: (CellType,Model) -> ()
    
    init(cellIdentifier: String, items: [Model], configureCell: @escaping (CellType, Model) -> ()) {
        self.configureCell = configureCell
        super.init()
        
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CellType else { return UITableViewCell() }
        let object = self.items[indexPath.row]
        configureCell(cell, object)
        return cell
    }
}
