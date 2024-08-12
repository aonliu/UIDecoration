# UIDecoration
UIDecoration is a swift framework to help create view decoration

## Requirements

- iOS 12.0+
- Swift 5.0+

## Installation

### CocoaPods

To integrate SnapKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UIDecoration'
end
```

## Usage

### Direct use decoration to view

Just set a DecorationItem object to decoration function will set style，in general, should use DecorationItem.r to create a DecorationItem object

```swift
let label = UILabel()
/// decoration —— font: regular12, textColor: black, textAlignment: center, numberOfLines: 0
label.decoration(.r.r12.color(.black).align(.center).unlimited)

let view = UIView.init()
/// decoration —— backgroundColor: orange, isUserInteractionEnabled: false
view.decoration(.r.ground(.orange).unInteraction)
```
Some decoration have different feature，such as：text(_ value: String?) will set text to UILabel, will set normal title to UIButton; font(_ value: UIFont?) will set font to UILabel, will set UIButtonTitleLabel font to UIButton;

```swift
let label = UILabel()
/// decoration —— text: "this is text", font: regular10
label.decoration(.r.text("this is text").font(.r10))

let button = UIButton.init(type: .custom)
/// decoration —— noralTitle: "this is text", font: regular10
button.decoration(.r.text("this is text").font(.r10))
```
Each decorator only works for valid views，such as：text(_ value: String?) is effective to UILabel, UITextField, UITextView, UIButton, but still can set decoration to other type view，it just invalid and will not crash
```swift
let label = UILabel()
/// decoration —— backgroundColor:red, text: "this is text", font: regular10
label.decoration(.r.ground(.red).text("this is text").font(.r10))

let view = UIView()
/// decoration —— backgroundColor:orange, text and font not support
view.decoration(.r.ground(.orange).text("this is text").font(.r10))
```

### Extract universal objects

The same effect can be extracted as independent DecorationItem objects, and the required views can be referenced separately, According to the order wil cover equal decoration

```swift
extension DecorationItem {
    // decoration —— cornerRadius: 12, backgroundColor: white, shadow: black 16 4
    var item: DecorationItem { radius(12).shadow(color: .black, blur: 16, offset: .init(width: 0, height: 4)) }
}

let view1 = UIView()
/// will use item decoration
view1.decoration(.r.item)

let view2 = UIView()
/// will use item decoration, and cover backgroundColor set to orange
view2.decoration(.r.item.ground(.orange))
```
### Extension Style
Maybe you want to extension some decoration to some view, such as,  third-party view [YYLabel](https://github.com/ibireme/YYText) is very popular, but is subclass of UIView not UILabel, so if you want to use decoration to set font, text, color..., use protocol DecorationExtend

```swift
// extension Decoration to YYLabel
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
    
    public func attributedTextExtend(_ value: NSAttributedString?) {
        self.attributedText = value
    }
}

let label = YYLabel()
///  decoration —— text: "this is text", font: regular12, textColor: black
label.decoration(.r.text("this is text").r14.color(.black))
```
### Create Custom DecorationItem
You can use copyPush function to create custom DecorationItem, eg: create a text2(_ value: String?)
```swift
// create custome decorationItem text2
extension DecorationItem {
    @discardableResult func text2(_ value: String?) -> DecorationItem {
        /// set copyPush key and function, is not set key, key will use #function
        copyPush("text2") { view in
            if let element = view as? UIButton {
                element.setTitle(value, for: .normal)
            }
            if view is TextContainer {
                view.setValue(value, forKey: "text")
            }
        }
    }
}

let label = UILabel()
///  decoration —— text2: "this is decorateItem text2"
label.decoration(.r.text2("this is decorateItem text2 test"))
```
