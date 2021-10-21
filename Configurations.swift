//
//  Configurations.swift
//  TCL
//
//  Created by Mirza Ahmer Baig on 03/07/2018.
//  Copyright © 2018 Mirza Ahmer Baig. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
    func updateItem(item: Any)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    var item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
    
    func updateItem(item: Any) {
        self.item = item as! DataType
    }
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    var item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func updateItem(item: Any) {
        self.item = item as! DataType
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}
