//
//  LeftViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/26/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = LMTableViewDataModel()
    fileprivate var dataArray = [LMTableViewDataModelItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DRHTableViewCell.nib, forCellReuseIdentifier: DRHTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        dataSource.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData()
    }
}

extension LeftViewController : LMTableViewDataModelDelegate {
    
    func didRecieveDataUpdate(data: [LMTableViewDataModelItem]) {
        dataArray = data
    }
}

extension LeftViewController: UITableViewDelegate {
   
    // TODO: Finish Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch dataArray[indexPath.row].title! {
            
        case "Navegación":
            let mapVC = MapViewController.newInstance()
            self.navigationController?.present(mapVC, animated: true, completion: nil)
//            self.navigationController?.pushViewController(mapVC, animated: true)
        case "Unidades de medida": break
        case "Idioma": break
        case "Ajustes": break
        case "Información": break
        default:
            return
        }
    }
    
}

extension LeftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: DRHTableViewCell.identifier, for: indexPath) as? DRHTableViewCell {
            
            cell.configureWithItem(item: dataArray[indexPath.item])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  dataArray.count
    }
    
}
