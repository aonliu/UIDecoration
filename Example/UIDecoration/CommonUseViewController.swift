//
//  CommonUseViewController.swift
//  UIDecoration_Example
//
//  Created by  刘剑云 on 2024/8/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import UIDecoration

class CommonUseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let scrollView = view.addScroll()
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let column = scrollView.addLeadingColumn().decoration(.r.space(10))
        column.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        column.addLabel().decoration(.r.text("这是分别使用装饰器").color(.gray))
        let row1 = column.addCenterRow().decoration(.r.space(10).after(30))
        row1.addLabel().decoration(.r.unlimited.text("这是一个文字"))
        row1.addButton().decoration(.r.ground(.red).text("这是一个按钮"))
        row1.addImage(.location)
        
        column.addLabel().decoration(.r.text("这是组合装饰器").color(.gray))
        let row2 = column.addCenterRow().decoration(.r.space(10))
        row2.addButton().decoration(.r.item1.ground(.orange).text("按钮1"))
        row2.addButton().decoration(.r.item1.text("按钮2").color(.black))
        let testView = row2.addView().decoration(.r.item1.item2)
        testView.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        
    }
}

extension DecorationItem {
    var item1: DecorationItem { radius(12).ground(.white).padding(.init(top: 20, left: 20, bottom: 20, right: 20)).shadow(.init(color: .black, blur: 16, offset: .init(width: 0, height: 4))) }
    var item2: DecorationItem { ground(.blue).radius(8) }
}
