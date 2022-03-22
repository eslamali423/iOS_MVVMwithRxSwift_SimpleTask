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
      // Edit user
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath.row)
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser (title : textField.text ?? "" , index : indexPath.row) 
                
            }))
            
            
        }).disposed(by: bag)
     // delete user
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.viewModel.deleteUser(index: indexPath.row)
        })
        
        
        
    }


    @IBAction func didTapAddButton(_ sender: Any) {
        let user =  User(id: 123, userId: 123, title: "New User", body: "newUserBody")
        self.viewModel.addUser(user: user)
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

