//
//  SearchAddressViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import Material

class SearchAddressViewController: UIViewController {
    
    @IBOutlet weak var ciudadTextField: TextField!
    @IBOutlet weak var calleFirstTextField: TextField!
    @IBOutlet weak var calleSecondTextField: TextField!
    
    @IBOutlet weak var tableView: UITableView?
    
    fileprivate var dataArray = [SearchAddressDataModelItem]() {
        didSet {
            tableView?.reloadData()
        }
    }
    private let searchDataSource = SearchAddressDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsColors()
        
        tableView?.register(SearchAddressTableViewCell.nib, forCellReuseIdentifier: SearchAddressTableViewCell.identifier)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        searchDataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
        searchDataSource.requestData()
    }
    
    fileprivate func setTextFieldsColors() {
        ciudadTextField.textColor = #colorLiteral(red: 0, green: 0.4093408585, blue: 0.7921054959, alpha: 1)
        calleFirstTextField.textColor = #colorLiteral(red: 0, green: 0.4093408585, blue: 0.7921054959, alpha: 1)
        calleSecondTextField.textColor = #colorLiteral(red: 0, green: 0.4093408585, blue: 0.7921054959, alpha: 1)
    }
    
    @IBAction func searchForAddress(_ sender: Any) {
        searchDataSource.requestData()
    }
}

extension SearchAddressViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row selected \(indexPath.item)")
    }
    
}

extension SearchAddressViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchAddressTableViewCell.identifier, for: indexPath) as? SearchAddressTableViewCell {
            
            cell.configureWithItem(item: dataArray[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return dataArray.count
    }
}

extension SearchAddressViewController: SearchAddressDataModelDelegate {
    
    func didRecieveDataUpdate(data: [SearchAddressDataModelItem]) {
        dataArray = data
    }
}
