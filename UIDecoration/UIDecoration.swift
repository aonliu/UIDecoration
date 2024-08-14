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
    /// set decoration
    /// - Parameter items: each decorationItem, every DecorationItem object include some decoration feature
    /// - Returns: caller
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
    
    /// add a new decoration feature
    /// - Parameters:
    ///   - key: key, equal key will cover feature
    ///   - value: feature block, set view property in this block
    /// - Returns: added decorationItem
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
    /// set frame
    @discardableResult func frame(_ value: CGRect) -> DecorationItem {
        self.copyPush { view in
            view.frame = value
        }
    }
    /// set clipsToBounds
    @discardableResult func isClips(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.clipsToBounds = value
        }
    }
    /// set clipsToBounds: true
    var clip: DecorationItem {
        isClips(true)
    }
    /// set backgroundColor
    @discardableResult func ground(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            view.backgroundColor = value
        }
    }
    /// set backgroundColor: clear
    var blank: DecorationItem {
        ground(.clear)
    }
    /// set tag
    @discardableResult func tag(_ value: Int) -> DecorationItem {
        copyPush { view in
            view.tag = value
        }
    }
    // set image to UIImageView, set stateNormalImage to UIButton will set stateNormalImage, set layer.contents to UIView
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
    /// set transform
    @discardableResult func transform(_ value: CGAffineTransform) -> DecorationItem {
        copyPush { view in
            view.transform = value
        }
    }
    /// set layer.zPosition
    @discardableResult func zPosition(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.layer.zPosition = value
        }
    }
    /// set isUserInteractionEnabled
    @discardableResult func isInteraction(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isUserInteractionEnabled = value
        }
    }
    /// set isUserInteractionEnabled: true
    var interaction: DecorationItem {
        isInteraction(true)
    }
    /// set isUserInteractionEnabled: false
    var unInteraction: DecorationItem {
        isInteraction(false)
    }
    /// set highlighted
    @discardableResult func isHighlighted(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.isHighlightedExtend(_:)))  {
                expand.isHighlightedExtend?(value)
            }else if view is UIControl || view is UIImageView || view is UITableViewCell || view is UICollectionViewCell || view is UILabel {
                view.setValue(value, forKey: "highlighted")
            }
        }
    }
    /// set highlighted: true
    var highlighted: DecorationItem {
        isHighlighted(true)
    }
    /// set selected
    @discardableResult func isSelected(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.isSelectedExtend(_:)))  {
                expand.isSelectedExtend?(value)
            }else if view is UIControl || view is UITableViewCell || view is UICollectionViewCell {
                view.setValue(value, forKey: "selected")
            }
        }
    }
    /// set selected: true
    var selected: DecorationItem {
        isSelected(true)
    }
    /// set selected: false
    var unSelected: DecorationItem {
        isSelected(false)
    }
    /// set enable
    @discardableResult func isEnabled(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if view is UIControl || view is UILabel {
                view.setValue(value, forKey: "enabled")
            }
        }
    }
    /// set enable: true
    var enable: DecorationItem {
        isEnabled(true)
    }
    /// set enable: false
    var disable: DecorationItem {
        isEnabled(false)
    }
    /// set alpha
    @discardableResult func alpha(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.alpha = value
        }
    }
    /// set alpha: 0
    var clear: DecorationItem {
        alpha(0)
    }
    /// set opaque
    @discardableResult func isOpaque(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isOpaque = value
        }
    }
    /// set hidden
    @discardableResult func isHidden(_ value: Bool) -> DecorationItem {
        copyPush { view in
            view.isHidden = value
        }
    }
    /// set !ishidden
    @discardableResult func isVisiable(_ value: Bool) -> DecorationItem {
        isHidden(!value)
    }
    /// set hidden: true
    var hidden: DecorationItem {
        isHidden(true)
    }
    /// set hidden: false
    var visiable: DecorationItem {
        isHidden(false)
    }
    /// set hidden: true & alpha: 0
    var gone: DecorationItem {
        isHidden(true).alpha(0)
    }
    /// set contentMode
    @discardableResult func fit(_ value: UIView.ContentMode) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.fitExtend(_:)))  {
                expand.fitExtend?(value)
            }else {
                view.contentMode = value
            }
        }
    }
    /// set contentMode: scaleAspectFit
    var aspectFit: DecorationItem {
        fit(.scaleAspectFit)
    }
    /// set contentMode: scaleAspectFill & clipsToBounds: true
    var aspectFill: DecorationItem {
        fit(.scaleAspectFill).clip
    }
    /// set mask
    @discardableResult func mask(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            view.mask = value
        }
    }
    /// set tintColor
    @discardableResult func tint(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            view.tintColor = value
        }
    }
    /// set layer.cornerRadius
    @discardableResult func radius(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            view.layer.cornerRadius = value
        }
    }
    /// set layer.cornerRadius & clipsToBounds: true
    @discardableResult func clipRadius(_ value: CGFloat) -> DecorationItem {
        radius(value).isClips(true)
    }
    /// set layer.maskedCorners
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
    /// set layer.borderColor & layer.borderWidth
    @discardableResult func border(_ color: UIColor, _ width: CGFloat = 1) -> DecorationItem {
        copyPush { view in
            view.layer.borderWidth = width
            view.layer.borderColor = color.cgColor
        }
    }
    /// set shadow
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
    /// set shadow
    @discardableResult func shadow(color: UIColor, blur: CGFloat, offset: CGSize) -> DecorationItem {
        shadow(.init(color: color, blur: blur, offset: offset))
    }
}
/// about ImageView
public extension DecorationItem {
    /// set highlightedImage
    @discardableResult func highlightedSrc(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.highlightedImage = value
            }
        }
    }
    /// set image, highlightedImage
    @discardableResult func highlightedImage(_ normal: UIImage?, _ highlighted: UIImage?) -> DecorationItem {
        src(normal).highlightedSrc(highlighted)
    }
    /// set image, highlightedImage
    @discardableResult func highlightedImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        src(value.off).highlightedSrc(value.on)
    }
    /// set animationImages
    @discardableResult func animationImages(_ value: [UIImage]) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.animationImages = value
            }
        }
    }
    /// set highlightedAnimationImages to UIImageView
    @discardableResult func highlightedAnimationImages(_ value: [UIImage]) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.highlightedAnimationImages = value
            }
        }
    }
    /// set animationDuration, animationRepeatCount to UIImageView
    @discardableResult func animation(_ duration: TimeInterval, _ count: Int = 0) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIImageView {
                element.animationDuration = duration
                element.animationRepeatCount = count
            }
        }
    }
}
/// about UIButton, UIControl
public extension DecorationItem {
    /// set stateTitle to UIButton
    @discardableResult func stateTitle(_ value: String?, _ state: UIControl.State = .normal) -> DecorationItem {
        return self.copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setTitle(value, for: state)
            }
        }
    }
    /// set stateTitleColor to UIButton
    @discardableResult func stateColor(_ value: UIColor?, _ state: UIControl.State = .normal) -> DecorationItem {
        return self.copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setTitleColor(value, for: state)
            }
        }
    }
    /// set stateImage to UIButton
    @discardableResult func stateImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setImage(value, for: state)
            }
        }
    }
    /// set stateBackgroundImage to UIButton
    @discardableResult func stateBackgroundImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setBackgroundImage(value, for: state)
            }
        }
    }
    /// set stateAttributeTitle to UIButton
    @discardableResult func stateAttributedTitle(_ value: NSAttributedString?, _ state: UIControl.State = .normal) -> DecorationItem {
        copyPush("\(#function)\(state.rawValue)") { view in
            if let element = view as? UIButton {
                element.setAttributedTitle(value, for: state)
            }
        }
    }
    /// set button normalStateImage, selectedStateImage
    @discardableResult func selectedImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateImage(value.off)
            .stateImage(value.off, [.normal, .highlighted])
            .stateImage(value.on, .selected)
            .stateImage(value.on, [.selected, .highlighted])
    }
    /// set button normalStateTitle, selectedStateTitle
    @discardableResult func selectedTitle(_ value: SwitchState<String?>) -> DecorationItem {
        stateTitle(value.off)
            .stateTitle(value.off, [.normal, .highlighted])
            .stateTitle(value.on, .selected)
            .stateTitle(value.on, [.selected, .highlighted])
    }
    /// set button normalStateTitleColor, selectedStateTitleColor
    @discardableResult func selectedColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        stateColor(value.off)
            .stateColor(value.off, [.normal, .highlighted])
            .stateColor(value.on, .selected)
            .stateColor(value.on, [.selected, .highlighted])
    }
    /// set button normalStateBackgroundImage, selectedStateBackgroundImage
    @discardableResult func selectedBackgroundImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateBackgroundImage(value.off)
            .stateBackgroundImage(value.off,  [.normal, .highlighted])
            .stateBackgroundImage(value.on, .selected)
            .stateBackgroundImage(value.on, [.selected, .highlighted])
    }
    /// set button normalStateTitleColor, disabledStateTitleColor
    @discardableResult func disabledColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        stateColor(value.off)
            .stateColor(value.off, [.normal, .highlighted])
            .stateColor(value.on, .disabled)
            .stateColor(value.on, [.disabled, .highlighted])
    }
    /// set normalStateBackgroundImage, selectedStateBackgroundImage to UIButton
    @discardableResult func disabledBackgroundImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateBackgroundImage(value.off)
            .stateBackgroundImage(value.off,  [.normal, .highlighted])
            .stateBackgroundImage(value.on, .disabled)
            .stateBackgroundImage(value.on, [.disabled, .highlighted])
    }
    /// set normalStateImage, selectedStateImage to UIButton
    @discardableResult func disabledImage(_ value: SwitchState<UIImage?>) -> DecorationItem {
        stateImage(value.off, .normal)
            .stateImage(value.off, [.normal, .highlighted])
            .stateImage(value.on, .disabled)
            .stateImage(value.on, [.disabled, .highlighted])
    }
    /// set contentEdgeInsets to UIButton, set contentInset to UIScrollView, set textContainerInset to UITextView
    @discardableResult func padding(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.paddingExtend(_:)))  {
                expand.paddingExtend?(value)
            }else {
                if let element = view as? UIButton {
                    element.contentEdgeInsets = value
                }else if let element = view as? UITextView {
                    element.contentInset = .zero
                    element.textContainer.lineFragmentPadding = .zero
                    element.textContainerInset = value
                }else if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                    element.contentInset = value
                }
            }
        }
    }
    /// set titleEdgeInsets to UIButton
    @discardableResult func titleInset(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIButton {
                element.titleEdgeInsets = value
            }
        }
    }
    /// set imageEdgeInsets to UIButton
    @discardableResult func imageInset(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIButton {
                element.imageEdgeInsets = value
            }
        }
    }
    /// set contentVerticalAlignment to UIControl
    @discardableResult func verticalAlign(_ value: UIControl.ContentVerticalAlignment) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIControl {
                element.contentVerticalAlignment = value
            }
        }
    }
    /// set contentHorizontalAlignment to UIControl
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
    /// set estimatedRowHeight or rowHeight to UITableView
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
    /// set separatorInset to UITableView or UITableViewCell
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
    /// set separatorStyle to UITableView
    @discardableResult func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorStyle = value
            }
        }
    }
    /// set separatorColor to UITableView
    @discardableResult func separatorColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorColor = value
            }
        }
    }
    /// set separatorEffect to UITableView
    @discardableResult func separatorEffect(_ value: UIVisualEffect?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.separatorEffect = value
            }
        }
    }
    /// set tableHeaderView to UITableView
    @discardableResult func header(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.tableHeaderView = value
            }
        }
    }
    /// set tableFooterView to UITableView
    @discardableResult func footView(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableView {
                element.tableFooterView = value
            }
        }
    }
}
/// about TableViewCell
public extension DecorationItem {
    /// set selectedBackgroundColor to UITableViewCell
    @discardableResult func selectedColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                let backgroundView = UIView.init()
                backgroundView.backgroundColor = value
                element.selectedBackgroundView = backgroundView
            }
        }
    }
    /// set accessoryType to UITableViewCell
    @discardableResult func accessoryType(_ value: UITableViewCell.AccessoryType) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.accessoryType = value
            }
        }
    }
    /// set accessoryView to UITableViewCell
    @discardableResult func accessoryView(_ value: UIView?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.accessoryView = value
            }
        }
    }
    /// set indentationWidth to UITableViewCell
    @discardableResult func indentationWidth(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITableViewCell {
                element.indentationLevel = 1
                element.indentationWidth = value
            }
        }
    }
}
/// about StackView
public extension DecorationItem {
    /// set axit to UIStackView
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
    /// set alignment to UIStackView
    @discardableResult func stackAlign(_ value: UIStackView.Alignment) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIStackView {
                element.alignment = value
            }
        }
    }
    /// set spacing to UIStackView
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
    /// set distribution to UIStackView
    @discardableResult func distribution(_ value: UIStackView.Distribution) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIStackView {
                element.distribution = value
            }
        }
    }
    /// set distribution: fillEqually to UIStackView
    var fillEqually: DecorationItem {
        distribution(.fillEqually)
    }
    /// set distribution: equalSpacing to UIStackView
    var equalSpacing: DecorationItem {
        distribution(.equalSpacing)
    }
    /// set distribution: equalCentering to UIStackView
    var equalCentering: DecorationItem {
        distribution(.equalCentering)
    }
    /// set customSpacing
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

/// about UILabel
public extension DecorationItem {
    /// set lineBreakMode to UILabel & UIButton.titleLabel
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

/// about text
public extension DecorationItem {
    /// set font to UILabel & UITextView & UITextField & UIButton.titleLabel
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
    /// set textAlignment to UILabel & UITextView & UITextField
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
    /// set numberOfLines to UILabel & UITextView & UITextField & UIButton.titleLabel
    @discardableResult func lines(_ value: Int) -> DecorationItem {
        copyPush { view in
            if let expand = view as? DecorationExtend,  expand.responds(to: #selector(DecorationExtend.linesExtend(_:)))  {
                expand.linesExtend?(value)
            }else {
                if let element = view as? UIButton {
                    element.titleLabel?.numberOfLines = value
                }
                if view is TextContainer {
                    view.setValue(value, forKey: "numberOfLines")
                }
            }
        }
    }
    /// set numberOfLines: 0
    var unlimited: DecorationItem {
        lines(0)
    }
    /// set text to UILabel & UITextView & UITextField, set normalStateTitle to UIButton
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
    /// set priority
    @discardableResult func priority(_ value: Float) -> DecorationItem {
        copyPush { view in
            view.setContentHuggingPriority(.init(rawValue: value), for: .horizontal)
            view.setContentCompressionResistancePriority(.init(rawValue: value), for: .horizontal)
            view.setContentHuggingPriority(.init(rawValue: value), for: .vertical)
            view.setContentCompressionResistancePriority(.init(rawValue: value), for: .vertical)
        }
    }
    /// set attributedText to UILabel & UITextView & UITextField, set normalStateAttributedTitle to UIButton
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
    /// set textColor to UILabel & UITextView & UITextField, set normalStateTitleColor to UIButton
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
    /// set highlightedTextColor to UILabel
    @discardableResult func highlightedColor(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UILabel {
                element.highlightedTextColor = value
            }
        }
    }
    /// set textColor, set highlightedTextColor
    @discardableResult func highlightedColor(_ normal: UIColor, _ highlighted: UIColor?) -> DecorationItem {
        color(normal).highlightedColor(highlighted)
    }
}
/// about TextInput
public extension DecorationItem {
    /// set autocapitalizationType to UITextField & UITextView
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
    /// set autocorrectionType to UITextField & UITextView
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
    /// set spellCheckingType to UITextField & UITextView
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
    /// set keyboardType to UITextField & UITextView
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
    /// set keyboardAppearance to UITextField & UITextView
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
    /// set returnKeyType to UITextField & UITextView
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
    /// set enablesReturnKeyAutomatically to UITextField & UITextView
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
    /// set isSecureTextEntry to UITextField & UITextView
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
    /// set isSecureTextEntry: true to UITextField & UITextView
    var password: DecorationItem {
        isSecureTextEntry(true)
    }
    /// set isSecureTextEntry: false to UITextField & UITextView
    var plaintext: DecorationItem {
        isSecureTextEntry(false)
    }
}
/// about TextField
public extension DecorationItem {
    /// set placeholder to UITextField
    @discardableResult func placeholder(_ value: String) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.placeholder = value
            }
        }
    }
    /// set color attributedPlaceholder
    @discardableResult func colorPlaceholder(_ value: String, _ color: UIColor) -> DecorationItem {
        attributedPlaceholder(.init(string: value, attributes: [.foregroundColor: color]))
    }
    /// set attributedPlaceholder to UITextField
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
    /// set leftView & leftViewMode to UITextField
    @discardableResult func left(_ value: UIView?, _ modo: UITextField.ViewMode = .never) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.leftView = value
                element.leftViewMode = modo
            }
        }
    }
    /// set rightView & rightViewMode to UITextField
    @discardableResult func right(_ value: UIView?, _ modo: UITextField.ViewMode = .never) -> DecorationItem {
        copyPush { view in
            if let element = view as? UITextField {
                element.rightView = value
                element.rightViewMode = modo
            }
        }
    }
}
/// about ScrollView
public extension DecorationItem {
    /// set contentSize to UIScrollView
    @discardableResult func contentSize(_ value: CGSize) -> DecorationItem {
        copyPush { view in
            
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.contentSize = value
            }
        }
    }
    /// set directionalLockEnable to UIScrollView
    @discardableResult func isDirectionalLock(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.isDirectionalLockEnabled = value
            }
        }
    }
    /// set directionalLockEnable: true to UIScrollView
    var directionalLock: DecorationItem {
        isDirectionalLock(true)
    }
    /// set bounces to UIScrollView
    @discardableResult func bounces(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.bounces = value
            }
        }
    }
    /// set bounces: false to UIScrollView
    var unBounce: DecorationItem {
        bounces(false)
    }
    /// set alwaysBounceVertical to UIScrollView
    @discardableResult func alwaysBounceVertical(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.alwaysBounceVertical = value
            }
        }
    }
    /// set alwaysBounceVertical: true to UIScrollView
    var bounceVertical: DecorationItem {
        alwaysBounceVertical(true)
    }
    /// set alwaysBounceHorizontal to UIScrollView
    @discardableResult func alwaysBounceHorizontal(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.alwaysBounceHorizontal = value
            }
        }
    }
    /// set alwaysBounceHorizontal: true & alwaysBounceVertical: true to UIScrollView
    @discardableResult func alwaysBounce(_ value:Axial) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.alwaysBounceHorizontal = value.contains(.horizontal)
                element.alwaysBounceVertical = value.contains(.vertical)
            }
        }
    }
    /// set pagingEnabled to UIScrollView
    @discardableResult func isPaging(_ value:Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.isPagingEnabled = value
            }
        }
    }
    /// set pagingEnabled: true to UIScrollView
    var paging: DecorationItem {
        isPaging(true)
    }
    /// set scrollEnabled to UIScrollView
    @discardableResult func isScroll(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.isScrollEnabled = value
            }
        }
    }
    /// set scrollEnabled: false to UIScrollView
    var unScroll: DecorationItem {
        isScroll(false)
    }
    /// set delaysContentTouches to UIScrollView
    @discardableResult func delaysTouches(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.delaysContentTouches = value
            }
        }
    }
    /// set delaysContentTouches: false to UIScrollView
    var instantlyTouches: DecorationItem {
        delaysTouches(false)
    }
    /// set showsVerticalScrollIndicator to UIScrollView
    @discardableResult func verticalIndicator(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.showsVerticalScrollIndicator = value
            }
        }
    }
    /// set verticalScrollIndicatorInsets to UIScrollView
    @discardableResult func verticalIndicatorInsets(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.verticalScrollIndicatorInsets = value
            }
        }
    }
    /// set showsHorizontalScrollIndicator to UIScrollView
    @discardableResult func horizontalIndicator(_ value: Bool) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.showsHorizontalScrollIndicator = value
            }
        }
    }
    /// set horizontalScrollIndicatorInsets to UIScrollView
    @discardableResult func horizontalIndicatorInsets(_ value: UIEdgeInsets) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.horizontalScrollIndicatorInsets = value
            }
        }
    }
    /// set minimumZoomScale to UIScrollView
    @discardableResult func minZoom(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.minimumZoomScale = value
            }
        }
    }
    /// set maximumZoomScale to UIScrollView
    @discardableResult func maxZoom(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.maximumZoomScale = value
            }
        }
    }
    /// set minimumZoomScale & maximumZoomScale to UIScrollView
    @discardableResult func zoomRange(_ min: CGFloat, _ max: CGFloat) -> DecorationItem {
        self.minZoom(min).maxZoom(max)
    }
    /// set showsHorizontalScrollIndicator & showsVerticalScrollIndicator to UIScrollView
    @discardableResult func indicator(_ value: Axial) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.showsHorizontalScrollIndicator = value.contains(.horizontal)
                element.showsVerticalScrollIndicator = value.contains(.vertical)
            }
        }
    }
    /// set showsHorizontalScrollIndicator: false & showsVerticalScrollIndicator: false to UIScrollView
    var unIndicator: DecorationItem {
        indicator([])
    }
    /// set showsVerticalScrollIndicator: true to UIScrollView
    var vIndicator: DecorationItem {
        indicator([.vertical])
    }
    /// set showsHorizontalScrollIndicator: true to UIScrollView
    var hIndicator: DecorationItem {
        indicator([.horizontal])
    }
    /// set contentInsetAdjustmentBehavior to UIScrollView
    @discardableResult func behavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.contentInsetAdjustmentBehavior = value
            }
        }
    }
    /// set contentInsetAdjustmentBehavior: never to UIScrollView
    var neverBehavior: DecorationItem {
        behavior(.never)
    }
    /// set indicatorStyle to UIScrollView
    @discardableResult func indicatorStyle(_ value:UIScrollView.IndicatorStyle) -> DecorationItem {
        copyPush { view in
            if let element = (view as? DecorationExtendScrollView)?.extendScrollView {
                element.indicatorStyle = value
            }
        }
    }
}

public extension DecorationItem {
    /// set pageIndicatorTintColor to UIPageControl
    @discardableResult func indicatorColor(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.pageIndicatorTintColor = value
            }
        }
    }
    /// set currentPageIndicatorTintColor to UIPageControl
    @discardableResult func currentIndicatorColor(_ value: UIColor) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.currentPageIndicatorTintColor = value
            }
        }
    }
    /// set pageIndicatorTintColor & currentPageIndicatorTintColor to UIPageControl
    @discardableResult func selectedIndicatorColor(_ value: SwitchState<UIColor?>) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.pageIndicatorTintColor = value.off
                element.currentPageIndicatorTintColor = value.on
            }
        }
    }
    @available(iOS 14.0, *)
    /// set backgroundStyle to UIPageControl
    @discardableResult func backgroundStyle(_ value: UIPageControl.BackgroundStyle) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIPageControl {
                element.backgroundStyle = value
            }
        }
    }
}

///about ProgressView
public extension DecorationItem {
    /// set progressViewStyle to UIPageControl
    @discardableResult func progressStyle(_ value: UIProgressView.Style) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressViewStyle = value
            }
        }
    }
    /// set progress to UIPageControl
    @discardableResult func progress(_ value: CGFloat) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progress = Float(value)
            }
        }
    }
    /// set progressTintColor to UIPageControl
    @discardableResult func progressTint(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressTintColor = value
            }
        }
    }
    /// set trackTintColor to UIPageControl
    @discardableResult func trackTint(_ value: UIColor?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.trackTintColor = value
            }
        }
    }
    /// set progressImage to UIPageControl
    @discardableResult func progressImage(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.progressImage = value
            }
        }
    }
    /// set trackImage to UIPageControl
    @discardableResult func trackImage(_ value: UIImage?) -> DecorationItem {
        copyPush { view in
            if let element = view as? UIProgressView {
                element.trackImage = value
            }
        }
    }
}

public extension DecorationItem {
    /// set effect to UIVisualEffectView
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

/// decoration extend
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
    @objc optional func linesExtend(_ value: Int)
}

/// if view response will call scrollview decorationItem, UIScrollView & WKWebView already call this protocol
@objc public protocol DecorationExtendScrollView {
    var extendScrollView: UIScrollView { get }
}

extension UIScrollView: DecorationExtendScrollView {
    public var extendScrollView: UIScrollView { return self }
}

extension WKWebView: DecorationExtendScrollView {
    public var extendScrollView: UIScrollView { return scrollView }
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

/// state object, can use array init, such as [value1, value2] or just use [value1]
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
    /// normal state
    public var off: T
    /// on state
    public var on: T
    
    public init(off: T, on: T) {
        self.off = off
        self.on = on
    }
}
