//
//  UIDecoration.swift
//  UIDecoration
//
//  Created by  刘剑云 on 2024/8/9.
//

import UIKit
import WebKit

public protocol ViewProperty {}
extension UIView: ViewProperty {}
public extension ViewProperty where Self: UIView {
    /// 设置装饰效果
    @discardableResult func decoration(_ items: DecorationItem...) -> Self {
        var keys: [DecorationKey: (UIView) -> Void] = [:]
        items.forEach { item in
            item.items.forEach { (key, value) in
                keys[key] = value
            }
        }
        keys.forEach { element in
            element.value(self)
        }
        return self
    }
    @discardableResult func frame(_ value: CGRect) -> Self {
        self.frame = value
        return self
    }
}

public class DecorationItem: NSCopying {
    public static let r = DecorationItem.init()
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = DecorationItem.init()
        items.forEach { item in
            copy.items[item.key] = item.value
        }
        return copy
    }
    
    var items: [DecorationKey: (UIView) -> Void] = [:]
    
    public func copyPush(_ key: DecorationKey = #function, value: @escaping (UIView) -> Void) -> DecorationItem {
        let result = self.copy() as! DecorationItem
        result.items[key] = value
        return result
    }
    
    func with(_ items: DecorationItem...) -> DecorationItem {
        let result = self.copy() as! DecorationItem
        items.forEach { item in
            item.items.forEach { (key, value) in
                result.items[key] = value
            }
        }
        return result
    }
}

/// view系列
public extension DecorationItem {
    @discardableResult func frame(_ value: CGRect) -> DecorationItem {
        self.copyPush { view in
            view.frame = value
        }
    }
    @discardableResult func isClips(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.clipsToBounds = value
        }
    }
    var clip: DecorationItem {
        isClips(true)
    }
    @discardableResult func ground(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            view.backgroundColor = value
        }
    }
    /// 背景颜色为空
    var blank: DecorationItem {
        ground(.clear)
    }
    @discardableResult func tag(_ value: Int) -> DecorationItem {
        copyPush { view in
            view.tag = value
        }
    }
    @discardableResult func src(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.srcExtend(_:)))  {
                expand.srcExtend?(value)
            }else {
                if let element = view as? UIImageView {
                    element.image = value
                }else if let element = view as? UIButton {
                    element.setImage(value, for: .normal)
                }else {
                    view.layer.contents = value?.cgImage
                }
            }
        }
    }
    
    @discardableResult func transform(_ value: CGAffineTransform) -> DecorationItem {
        copyPush { view in
            view.transform = value
        }
    }
    @discardableResult func zPosition(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.layer.zPosition = value
        }
    }
    @discardableResult func isInteraction(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isUserInteractionEnabled = value
        }
    }
    var interaction: DecorationItem {
        isInteraction(true)
    }
    /// 不可交互
    var unInteraction: DecorationItem {
        isInteraction(false)
    }
    @discardableResult func isHighlighted(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.isHighlightedExtend(_:)))  {
                expand.isHighlightedExtend?(value)
            }else if view is UIControl || view is UIImageView || view is UITableViewCell || view is UICollectionViewCell || view is UILabel {
                view.setValue(value, forKey: "highlighted")
            }
        }
    }
    var highlighted: DecorationItem {
        isHighlighted(true)
    }
    @discardableResult func isSelected(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.isSelectedExtend(_:)))  {
                expand.isSelectedExtend?(value)
            }else if view is UIControl || view is UITableViewCell || view is UICollectionViewCell {
                view.setValue(value, forKey: "selected")
            }
        }
    }
    var selected: DecorationItem {
        isSelected(true)
    }
    var unSelected: DecorationItem {
        isSelected(false)
    }
    @discardableResult func isEnabled(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if view is UIControl || view is UILabel {
                view.setValue(value, forKey: "enabled")
            }
        }
    }
    
    var enable: DecorationItem {
        isEnabled(true)
    }
    var disable: DecorationItem {
        isEnabled(false)
    }
    
    @discardableResult func alpha(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.alpha = value
        }
    }
    var clear: DecorationItem {
        alpha(0)
    }
    @discardableResult func isOpaque(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isOpaque = value
        }
    }
    @discardableResult func isHidden(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isHidden = value
        }
    }
    @discardableResult func isVisiable(_ value: Bool) -> DecorationItem {
        isHidden(!value)
    }
    var hidden: DecorationItem {
        isHidden(true)
    }
    var visiable: DecorationItem {
        isHidden(false)
    }
    var gone: DecorationItem {
        isHidden(true).alpha(0)
    }
    @discardableResult func fit(_ value: UIView.ContentMode) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.fitExtend(_:)))  {
                expand.fitExtend?(value)
            }else {
                view.contentMode = value
            }
        }
    }
    var aspectFit: DecorationItem {
        fit(.scaleAspectFit)
    }
    var aspectFill: DecorationItem {
        fit(.scaleAspectFill).clip
    }
    @discardableResult func mask(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            view.mask = value
        }
    }
    @discardableResult func tint(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            view.tintColor = value
        }
    }
    @discardableResult func radius(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.layer.cornerRadius = value
        }
    }
    @discardableResult func clipRadius(_ value: CGFloat) -> DecorationItem {
        radius(value).isClips(true)
    }
    
    @discardableResult func corner(_ value: UIRectCorner) -> DecorationItem {
        copyPush { view in
            var input = CACornerMask.init()
            if value.contains(.topLeft) {
                input.insert(.layerMinXMinYCorner)
            }
            if value.contains(.topRight) {
                input.insert(.layerMaxXMinYCorner)
            }
            if value.contains(.bottomLeft) {
                input.insert(.layerMinXMaxYCorner)
            }
            if value.contains(.bottomRight) {
                input.insert(.layerMaxXMaxYCorner)
            }
            if input.isEmpty {
                input = .init(rawValue: 15)
            }
            view.layer.maskedCorners = input
        }
    }
    
    @discardableResult func border(_ color: UIColor, _ width: CGFloat = 1) -> DecorationItem {
        copyPush { view in
            view.layer.borderWidth = width
            view.layer.borderColor = color.cgColor
        }
    }
    
    @discardableResult func shadow(_ value: Shadow) -> DecorationItem {
        copyPush { view in
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            value.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            view.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
            view.layer.shadowOpacity = Float(alpha)
            view.layer.shadowRadius = value.blur
            view.layer.shadowOffset = value.offset
        }
    }
    
    @discardableResult func shadow(color: UIColor, blur: CGFloat, offset: CGSize) -> DecorationItem {
        shadow(.init(color: color, blur: blur, offset: offset))
    }
}
/// ImageView相关
public extension DecorationItem {
    @discardableResult func highlightedSrc(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.highlightedImage = value
            }
        }
    }
    @discardableResult func highlightedImage(_ normal: UIImage?, _ highlighted: UIImage?) -> DecorationItem {
        src(normal).highlightedSrc(highlighted)
    }
    @discardableResult func highlightedImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        src(value.off).highlightedSrc(value.on)
    }

    @discardableResult func animationImages(_ value: [UIImage]) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.animationImages = value
            }
        }
    }
    @discardableResult func highlightedAnimationImages(_ value: [UIImage]) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.highlightedAnimationImages = value
            }
        }
    }
    @discardableResult func animation(_ duration: TimeInterval, _ count: Int = 0) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.animationDuration = duration
                element.animationRepeatCount = count
            }
        }
    }
}
/// Button, Control相关
public extension DecorationItem {
    @discardableResult func stateTitle(_ value: String?, _ state: UIControl.State = .normal) -> DecorationItem {
        return self.copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setTitle(value, for: state)
            }
        }
    }
    @discardableResult func stateColor(_ value: UIColor?, _ state: UIControl.State = .normal) -> DecorationItem {
        return self.copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setTitleColor(value, for: state)
            }
        }
    }
    @discardableResult func stateImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setImage(value, for: state)
            }
        }
    }
    @discardableResult func stateBackgroundImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setBackgroundImage(value, for: state)
            }
        }
    }
    @discardableResult func stateAttributedTitle(_ value: NSAttributedString?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setAttributedTitle(value, for: state)
            }
        }
    }
    @discardableResult func selectedImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateImage(value.off)
            .stateImage(value.off, [.normal, .highlighted])
            .stateImage(value.on, .selected)
            .stateImage(value.on, [.selected, .highlighted])
    }
    @discardableResult func selectedTitle(_ value: SwitchState<String?>) -> DecorationItem {
        stateTitle(value.off)
            .stateTitle(value.off, [.normal, .highlighted])
            .stateTitle(value.on, .selected)
            .stateTitle(value.on, [.selected, .highlighted])
    }
    @discardableResult func selectedColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        stateColor(value.off)
            .stateColor(value.off, [.normal, .highlighted])
            .stateColor(value.on, .selected)
            .stateColor(value.on, [.selected, .highlighted])
    }
    @discardableResult func selectedBackgroundImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateBackgroundImage(value.off)
            .stateBackgroundImage(value.off,  [.normal, .highlighted])
            .stateBackgroundImage(value.on, .selected)
            .stateBackgroundImage(value.on, [.selected, .highlighted])
    }
    @discardableResult func disabledColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        stateColor(value.off)
            .stateColor(value.off, [.normal, .highlighted])
            .stateColor(value.on, .disabled)
            .stateColor(value.on, [.disabled, .highlighted])
    }
    @discardableResult func disabledBackgroundImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateBackgroundImage(value.off)
            .stateBackgroundImage(value.off,  [.normal, .highlighted])
            .stateBackgroundImage(value.on, .disabled)
            .stateBackgroundImage(value.on, [.disabled, .highlighted])
    }
    @discardableResult func disabledImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateImage(value.off, .normal)
            .stateImage(value.off, [.normal, .highlighted])
            .stateImage(value.on, .disabled)
            .stateImage(value.on, [.disabled, .highlighted])
    }
    @discardableResult func padding(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.paddingExtend(_:)))  {
                expand.paddingExtend?(value)
            }else {
                if let element = view as? UIButton {
                    element.contentEdgeInsets = value
                }else if let element = view as? UIScrollView {
                    element.contentInset = value
                }else if let element = view as? UITextView {
                    element.contentInset = .zero
                    element.textContainer.lineFragmentPadding = .zero
                    element.textContainerInset = value
                }
            }
        }
    }
    @discardableResult func titleInset(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIButton {
                element.titleEdgeInsets = value
            }
        }
    }
    @discardableResult func imageInset(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIButton {
                element.imageEdgeInsets = value
            }
        }
    }
    @discardableResult func verticalAlign(_ value: UIControl.ContentVerticalAlignment) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIControl {
                element.contentVerticalAlignment = value
            }
        }
    }
    @discardableResult func horizontalAlign(_ value: UIControl.ContentHorizontalAlignment) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIControl {
                element.contentHorizontalAlignment = value
            }
        }
    }
}

/// UITableView相关
public extension DecorationItem {
    @discardableResult func rowHeight(_ value: CGFloat, estimated: Bool = false) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                if estimated {
                    element.estimatedRowHeight = value
                }else {
                    element.rowHeight = value
                }
            }
        }
    }
    @discardableResult func separatorInset(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorInset = value
            }
            if let element = view as? UITableViewCell {
                element.separatorInset = value
            }
        }
    }
    @discardableResult func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorStyle = value
            }
        }
    }
    @discardableResult func separatorColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorColor = value
            }
        }
    }
    @discardableResult func separatorEffect(_ value: UIVisualEffect?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorEffect = value
            }
        }
    }
    @discardableResult func header(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.tableHeaderView = value
            }
        }
    }
    @discardableResult func footView(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.tableFooterView = value
            }
        }
    }
}
/// TableViewCell相关
public extension DecorationItem {
    @discardableResult func selectedColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                let backgroundView = UIView.init()
                backgroundView.backgroundColor = value
                element.selectedBackgroundView = backgroundView
            }
        }
    }
    @discardableResult func accessoryType(_ value: UITableViewCell.AccessoryType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.accessoryType = value
            }
        }
    }
    @discardableResult func accessoryView(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.accessoryView = value
            }
        }
    }
    @discardableResult func indentationWidth(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.indentationLevel = 1
                element.indentationWidth = value
            }
        }
    }
}
/// StackView相关
public extension DecorationItem {
    @discardableResult func axis(_ value: NSLayoutConstraint.Axis) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.axisExtend(_:)))  {
                expand.axisExtend?(value)
            }else {
                if let element = view as? UIStackView {
                    element.axis = value
                }
            }
        }
    }
    @discardableResult func stackAlign(_ value: UIStackView.Alignment) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIStackView {
                element.alignment = value
            }
        }
    }
    @discardableResult func space(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.spaceExtend(_:)))  {
                expand.spaceExtend?(value)
            }else {
                if let element = view as? UIStackView {
                    element.spacing = value
                }
            }
        }
    }
    @discardableResult func distribution(_ value: UIStackView.Distribution) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIStackView {
                element.distribution = value
            }
        }
    }
    var fillEqually: DecorationItem {
        distribution(.fillEqually)
    }
    var equalSpacing: DecorationItem {
        distribution(.equalSpacing)
    }
    var equalCentering: DecorationItem {
        distribution(.equalCentering)
    }
    
    @discardableResult func after(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: DispatchWorkItem.init(block: {
                if let stack = view.superview as? UIStackView {
                    stack.setCustomSpacing(value, after: view)
                }
            }))
        }
    }
}

/// Label相关
public extension DecorationItem {
    @discardableResult func breakMode(_ value: NSLineBreakMode) -> DecorationItem {
        copyPush { view in
            if let button = view as? UIButton {
                button.titleLabel?.lineBreakMode = value
            }else if let label = view as? UILabel {
                label.lineBreakMode = value
            }
        }
    }
}

/// 文本公用相关
public extension DecorationItem {
    @discardableResult func font(_ value: UIFont?) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend, expand.responds(to: #selector(DecorationExtend.fontExtend(_:)))  {
                expand.fontExtend?(value)
            }else {
                if view is TextContainer {
                    view.setValue(value, forKey: "font")
                }
                if let button = view as? UIButton {
                    button.titleLabel?.font = value
                }
            }
        }
    }
    @discardableResult func regular(_ value: CGFloat) -> DecorationItem {
        return font(.regular(value))
    }
    @discardableResult func medium(_ value: CGFloat) -> DecorationItem {
        return font(.medium(value))
    }
    @discardableResult func semibold(_ value: CGFloat) -> DecorationItem {
        return font(.semibold(value))
    }
    @discardableResult func bold(_ value: CGFloat) -> DecorationItem {
        return font(.systemFont(ofSize: value, weight: .bold))
    }
    @discardableResult func align(_ value: NSTextAlignment) -> DecorationItem {
        copyPush { view in
            if view is TextContainer {
                view.setValue(NSNumber(value: value.rawValue), forKey: "textAlignment")
            }
        }
    }
    var center: DecorationItem {
        align(.center)
    }
    
    @discardableResult func lines(_ value: Int) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIButton {
                element.titleLabel?.numberOfLines = value
            }
            if view is TextContainer {
                view.setValue(value, forKey: "numberOfLines")
            }
        }
    }
    /// 不限制行数
    var unlimited: DecorationItem {
        lines(0)
    }
    @discardableResult func text(_ value: String?) -> DecorationItem {
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
    @discardableResult func priority(_ value: Float) -> DecorationItem {
        copyPush { view in
            view.setContentHuggingPriority(.init(rawValue: value), for: .horizontal)
            view.setContentCompressionResistancePriority(.init(rawValue: value), for: .horizontal)
            view.setContentHuggingPriority(.init(rawValue: value), for: .vertical)
            view.setContentCompressionResistancePriority(.init(rawValue: value), for: .vertical)
        }
    }
    
    @discardableResult func attributedText(_ value: NSAttributedString?) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.attributedTextExtend(_:)))  {
                expand.attributedTextExtend?(value)
            }else if let element = view as? UIButton {
                element.setAttributedTitle(value, for: .normal)
            }else if view is TextContainer {
                view.setValue(value, forKey: "attributedText")
            }
        }
    }
    /// 文本颜色，当作用对象为UIButton及其子类时，将设置normal状态下的文字颜色，当作用对象为TextContainer时，则设置文字颜色
    @discardableResult func color(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.colorExtend(_:)))  {
                expand.colorExtend?(value)
            }else if let element = view as? UIButton {
                element.setTitleColor(value, for: .normal)
            }else if view is TextContainer {
                view.setValue(value, forKey: "textColor")
            }
        }
    }
    @discardableResult func highlightedColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UILabel {
                element.highlightedTextColor = value
            }
        }
    }
    @discardableResult func highlightedColor(_ normal: UIColor, _ highlighted: UIColor?) -> DecorationItem {
        color(normal).highlightedColor(highlighted)
    }
}
/// TextInput相关
public extension DecorationItem {
    @discardableResult func autocapitalizationType(_ value: UITextAutocapitalizationType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.autocapitalizationType = value
            }
            if let element = view as? UITextView {
                element.autocapitalizationType = value
            }
        }
    }
    @discardableResult func autocorrectionType(_ value: UITextAutocorrectionType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.autocorrectionType = value
            }
            if let element = view as? UITextView {
                element.autocorrectionType = value
            }
        }
    }
    @discardableResult func spellChecking(_ value: UITextSpellCheckingType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.spellCheckingType = value
            }
            if let element = view as? UITextView {
                element.spellCheckingType = value
            }
        }
    }
    @discardableResult func keyboard(_ value: UIKeyboardType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.keyboardType = value
            }
            if let element = view as? UITextView {
                element.keyboardType = value
            }
        }
    }
    @discardableResult func keyboardAppearance(_ value: UIKeyboardAppearance) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.keyboardAppearance = value
            }
            if let element = view as? UITextView {
                element.keyboardAppearance = value
            }
        }
    }
    @discardableResult func returnKey(_ value: UIReturnKeyType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.returnKeyType = value
            }
            if let element = view as? UITextView {
                element.returnKeyType = value
            }
        }
    }
    @discardableResult func isReturnKeyAutomatically(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.enablesReturnKeyAutomatically = value
            }
            if let element = view as? UITextView {
                element.enablesReturnKeyAutomatically = value
            }
        }
    }
    @discardableResult func isSecureTextEntry(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.isSecureTextEntry = value
            }
            if let element = view as? UITextView {
                element.isSecureTextEntry = value
            }
        }
    }
    var password: DecorationItem {
        isSecureTextEntry(true)
    }
    var plaintext: DecorationItem {
        isSecureTextEntry(false)
    }
}
/// TextField相关
public extension DecorationItem {
    @discardableResult func placeholder(_ value: String) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.placeholder = value
            }
        }
    }
    @discardableResult func colorPlaceholder(_ value: String, _ color: UIColor) -> DecorationItem {
        attributedPlaceholder(.init(string: value, attributes: [.foregroundColor: color]))
    }
    @discardableResult func attributedPlaceholder(_ value: NSAttributedString?) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.attributedPlaceholderExtend(_:)))  {
                expand.attributedPlaceholderExtend?(value)
            }else {
                if let element = view as? UITextField {
                    element.attributedPlaceholder = value
                }
            }
        }
    }
    @discardableResult func left(_ value: UIView?, _ modo: UITextField.ViewMode = .never) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.leftView = value
                element.leftViewMode = modo
            }
        }
    }
    @discardableResult func right(_ value: UIView?, _ modo: UITextField.ViewMode = .never) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.rightView = value
                element.rightViewMode = modo
            }
        }
    }
}
/// ScrollView相关
public extension DecorationItem {
    @discardableResult func contentSize(_ value: CGSize) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.contentSize = value
            }
        }
    }
    @discardableResult func isDirectionalLock(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.isDirectionalLockEnabled = value
            }
        }
    }
    var directionalLock: DecorationItem {
        isDirectionalLock(true)
    }
    @discardableResult func bounces(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.bounces = value
            }else if let element = view as? WKWebView {
                element.scrollView.bounces = value
            }
        }
    }
    var unBounce: DecorationItem {
        bounces(false)
    }
    @discardableResult func alwaysBounceVertical(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.alwaysBounceVertical = value
            }
        }
    }
    var bounceVertical: DecorationItem {
        alwaysBounceVertical(true)
    }
    @discardableResult func alwaysBounceHorizontal(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.alwaysBounceHorizontal = value
            }
        }
    }
    @discardableResult func alwaysBounce(_ value:Axial) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.alwaysBounceHorizontal = value.contains(.horizontal)
                element.alwaysBounceVertical = value.contains(.vertical)
            }
        }
    }
    @discardableResult func isPaging(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.isPagingEnabled = value
            }
        }
    }
    var paging: DecorationItem {
        isPaging(true)
    }
    @discardableResult func isScroll(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.isScrollEnabled = value
            }
        }
    }
    var unScroll: DecorationItem {
        isScroll(false)
    }
    @discardableResult func delaysTouches(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.delaysContentTouches = value
            }
        }
    }
    var instantlyTouches: DecorationItem {
        delaysTouches(false)
    }
    @discardableResult func verticalIndicator(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.showsVerticalScrollIndicator = value
            }
        }
    }
    @discardableResult func horizontalIndicator(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.showsHorizontalScrollIndicator = value
            }
        }
    }
    @discardableResult func minZoom(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.minimumZoomScale = value
            }
        }
    }
    @discardableResult func maxZoom(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.maximumZoomScale = value
            }
        }
    }
    @discardableResult func zoomRange(_ min: CGFloat, _ max: CGFloat) -> DecorationItem {
        self.minZoom(min).maxZoom(max)
    }
    
    @discardableResult func indicator(_ value: Axial) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.showsHorizontalScrollIndicator = value.contains(.horizontal)
                element.showsVerticalScrollIndicator = value.contains(.vertical)
            }
        }
    }
    var unIndicator: DecorationItem {
        indicator([])
    }
    var vIndicator: DecorationItem {
        indicator([.vertical])
    }
    var hIndicator: DecorationItem {
        indicator([.horizontal])
    }
    @discardableResult func behavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.contentInsetAdjustmentBehavior = value
            }else if let element = view as? WKWebView {
                element.scrollView.contentInsetAdjustmentBehavior = value
            }
        }
    }
    var neverBehavior: DecorationItem {
        behavior(.never)
    }
    
    @discardableResult func indicatorStyle(_ value:UIScrollView.IndicatorStyle) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIScrollView {
                element.indicatorStyle = value
            }
        }
    }
}

public extension DecorationItem {
    @discardableResult func indicatorColor(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.pageIndicatorTintColor = value
            }
        }
    }
    @discardableResult func currentIndicatorColor(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.currentPageIndicatorTintColor = value
            }
        }
    }
    @discardableResult func selectedIndicatorColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.pageIndicatorTintColor = value.off
                element.currentPageIndicatorTintColor = value.on
            }
        }
    }
    @available(iOS 14.0, *)
    @discardableResult func backgroundStyle(_ value: UIPageControl.BackgroundStyle) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.backgroundStyle = value
            }
        }
    }
}

///ProgressView相关
public extension DecorationItem {
    @discardableResult func progressStyle(_ value: UIProgressView.Style) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressViewStyle = value
            }
        }
    }
    @discardableResult func progress(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progress = Float(value)
            }
        }
    }
    @discardableResult func progressTint(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressTintColor = value
            }
        }
    }
    @discardableResult func trackTint(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.trackTintColor = value
            }
        }
    }
    @discardableResult func progressImage(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressImage = value
            }
        }
    }
    @discardableResult func trackImage(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.trackImage = value
            }
        }
    }
}

public extension DecorationItem {
    @discardableResult func blur(_ value: UIBlurEffect.Style) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.blurExtend(_:)))  {
                expand.blurExtend?(value)
            }else {
                if let visual =  view as? UIVisualEffectView {
                    visual.effect = UIBlurEffect.init(style: value)
                }
            }
        }
    }
}

/// 属性扩展协议
@objc public protocol DecorationExtend: NSObjectProtocol {
    @objc optional func blurExtend(_ value: UIBlurEffect.Style)
    @objc optional func textExtend(_ value: String?)
    @objc optional func srcExtend(_ value: UIImage?)
    @objc optional func fitExtend(_ value: UIView.ContentMode)
    @objc optional func paddingExtend(_ value: UIEdgeInsets)
    @objc optional func attributedPlaceholderExtend(_ value: NSAttributedString?)
    @objc optional func fontExtend(_ value: UIFont?)
    @objc optional func isHighlightedExtend(_ value: Bool)
    @objc optional func isSelectedExtend(_ value: Bool)
    @objc optional func attributedTextExtend(_ value: NSAttributedString?)
    @objc optional func colorExtend(_ value: UIColor)
    @objc optional func axisExtend(_ value: NSLayoutConstraint.Axis)
    @objc optional func spaceExtend(_ value: CGFloat)
}

public typealias DecorationKey = String

public struct Shadow {
    var color: UIColor
    var blur: CGFloat
    var offset: CGSize
    
    public init(color: UIColor, blur: CGFloat, offset: CGSize) {
        self.color = color
        self.blur = blur
        self.offset = offset
    }
}

public protocol TextContainer {}
extension UILabel : TextContainer {}
extension UITextField: TextContainer {}
extension UITextView: TextContainer {}

public struct Axial: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let horizontal = Axial(rawValue: 1 << 0)
    public static let vertical = Axial(rawValue: 1 << 1)
    public static let all: Axial = [.horizontal, .vertical]
}

public extension UIRectCorner {
    static let top: UIRectCorner = [.topLeft, .topRight]
    static let right: UIRectCorner = [.topRight, .bottomRight]
    static let bottom: UIRectCorner = [.bottomLeft, .bottomRight]
    static let left: UIRectCorner = [.topLeft, .bottomLeft]
}

/// 状态，需要注意此用此struct的语义，off表示常规状态，on表示触发状态
public struct SwitchState<T>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = T
    
    public init(arrayLiteral elements: T...) {
        if elements.count == 1 {
            self.off = elements[0]
            self.on = elements[0]
        }else {
            self.off = elements[0]
            self.on = elements[1]
        }
    }
    /// 常规状态
    public var off: T
    /// 启动状态
    public var on: T
    
    public init(off: T, on: T) {
        self.off = off
        self.on = on
    }
}
