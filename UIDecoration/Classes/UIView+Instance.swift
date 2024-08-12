//
//  UIView+Instance.swift
//  UIDecoration
//
//  Created by  刘剑云 on 2024/8/9.
//

import Foundation

public extension UIView {
    @discardableResult func insert<T: UIView>(_ view: T) -> T {
        if let value = self as? UIStackView {
            value.addArrangedSubview(view)
        }else if let value = self as? UIVisualEffectView {
            value.contentView.addSubview(view)
        } else {
            view.insetsLayoutMarginsFromSafeArea = false
            addSubview(view)
        }
        return view
    }
    
    @discardableResult func addView() -> UIView {
        let view = UIView.init()
        return insert(view)
    }
    
    @discardableResult func addLabel(_ text: String? = nil) -> UILabel {
        let view = UILabel.init()
        view.text = text
        view.textColor = UILabel.appearance().textColor
        return insert(view)
    }
    
    @discardableResult func addButton(_ type: UIButton.ButtonType = .custom) -> UIButton {
        let view = UIButton.init(type: type)
        return insert(view)
    }
    
    @discardableResult func addImage(_ image: UIImage? = nil) -> UIImageView {
        let view = UIImageView.init(image: image)
        return insert(view)
    }
    @discardableResult func addCollction(_ layout: UICollectionViewLayout) -> UICollectionView {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return insert(view)
    }
    @discardableResult func addBlur(_ style: UIBlurEffect.Style) -> UIVisualEffectView {
        let view = UIVisualEffectView.init(effect: UIBlurEffect.init(style: style))
        return insert(view)
    }
    @discardableResult func addStack(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let view = UIStackView.init()
        view.axis = axis
        return insert(view)
    }
    @discardableResult func addRow() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .horizontal
        return insert(view)
    }
    @discardableResult func addColumn() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .vertical
        return insert(view)
    }
    @discardableResult func addControl() -> UIControl {
        let view = UIControl()
        return insert(view)
    }
    @discardableResult func addLeadingRow() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .horizontal
        view.alignment = .leading
        return insert(view)
    }
    @discardableResult func addLeadingColumn() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .vertical
        view.alignment = .leading
        return insert(view)
    }
    @discardableResult func addCenterRow() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .horizontal
        view.alignment = .center
        return insert(view)
    }
    @discardableResult func addCenterColumn() -> UIStackView {
        let view = UIStackView.init()
        view.axis = .vertical
        view.alignment = .center
        return insert(view)
    }
    @discardableResult func addScroll() -> UIScrollView {
        return insert(UIScrollView())
    }
    @discardableResult func addField() -> UITextField {
        let view = UITextField()
        view.textColor = .black
        return insert(view)
    }
    @discardableResult func addProgress(_ progressViewStyle: UIProgressView.Style = .default) -> UIProgressView {
        return insert(UIProgressView.init(progressViewStyle: progressViewStyle))
    }
}
