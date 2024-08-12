//
//  ViewController.swift
//  UIDecoration
//
//  Created by liujy on 08/09/2024.
//  Copyright (c) 2024 liujy. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let actions: [String] = [
        "直接使用",
        "属性扩展"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视图装饰器"
        let tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = actions[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(CommonUseViewController(), animated: true)
        }else {
            self.navigationController?.pushViewController(DecorationExtendViewController(), animated: true)
        }
    }
}

