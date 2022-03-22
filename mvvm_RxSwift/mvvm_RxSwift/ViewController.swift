//
//  ViewController.swift
//  mvvm_RxSwift
//
//  Created by Eslam Ali  on 22/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var viewModel = UserViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // tableView.delegate = self
     //   tableView.dataSource =  self

        viewModel.fetchUsers()
        bindTableView()
        
    }
    
    func  bindTableView() {
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row , userItem , cell in
            cell.textLabel?.text = userItem.title
            cell.detailTextLabel?.text = "\(userItem.id)"
            
        }.disposed(by: bag)
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath.row)
        }).disposed(by: bag)
        
        
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
       
        return cell
    }
    
    
}

