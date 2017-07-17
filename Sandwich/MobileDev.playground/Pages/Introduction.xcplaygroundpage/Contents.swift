/*:
 Mobile Development
 =====

 ![Sweet mobile dev graphic](mobile_dev.png)
 */





import UIKit

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

let imageView = UIImageView(image: #imageLiteral(resourceName: "mobile_dev.png"))
imageView.frame = view.frame
imageView.contentMode = .scaleAspectFit

let label = UILabel(frame: view.frame)
label.text = "Getting ideas from brain to phone"
label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
label.font = UIFont.systemFont(ofSize: 18, weight: 0.5)
label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
label.textAlignment = .center

view.addSubview(imageView)
view.addSubview(label)


//: [➡️](@next)
