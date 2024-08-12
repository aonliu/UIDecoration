//
//  DecorationExtendViewController.swift
//  UIDecoration_Example
//
//  Created by  刘剑云 on 2024/8/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import YYText
import UIDecoration

class DecorationExtendViewController: UIViewController {

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
        column.addLabel().decoration(.r.text("对YYLabel进行属性扩展示例").color(.gray))
        let yyLabel = column.insert(YYLabel()).decoration(.r.r14.color(.red))
        yyLabel.text = "北冥有鱼，其名为鲲"
        
        column.addLabel().decoration(.r.text("扩展一个新的装饰器").color(.gray))
        column.addLabel().decoration(.r.text2("这是扩展装饰器text2的测试"))
    }
}

extension DecorationItem {
    @discardableResult func text2(_ value: String?) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.textExtend(_:)))  {
                expand.textExtend?(value)
            }else {
                if let element = view as? UIButton {
                    element.setTitle(value, for: .normal)
                }
                if view is TextContainer {
                    view.setValue(value, forKey: "text")
                }
            }
        }
    }
}

extension YYLabel: DecorationExtend {
    public func paddingExtend(_ value: UIEdgeInsets) {
        self.textContainerInset = value
    }
    
    public func linesExtend(_ value: Int) {
        self.numberOfLines = UInt(value)
    }
    
    public func fontExtend(_ value: UIFont?) {
        self.font = value
    }
    
    public func colorExtend(_ value: UIColor) {
        self.textColor = value
    }
    
    public func textExtend(_ value: String?) {
        self.text = value
    }
    
    public func attributedTextExtend(_ value: NSAttributedString?) {
        self.attributedText = value
    }
}
