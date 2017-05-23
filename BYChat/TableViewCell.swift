import UIKit

class TableViewCell:UITableViewCell {
    var customView:UIView!
    var bubbleImage:UIImageView!
    var avatarImage:UIImageView!
    var msgItem:MessageItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(data:MessageItem, reuseIdentifier cellId:String) {
        self.msgItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    func rebuildUserInterface() {
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        if (self.bubbleImage == nil)
        {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
        }
        
        let type =  self.msgItem.mtype
        let width =  self.msgItem.view.frame.size.width
        let height =  self.msgItem.view.frame.size.height
        
        var x =  (type == ChatType.someone) ? 0 : self.frame.size.width - width -
            self.msgItem.insets.left - self.msgItem.insets.right
        
        var y:CGFloat =  0
        if (self.msgItem.user.username != "")
        {
            
            let thisUser =  self.msgItem.user
            //self.avatarImage.removeFromSuperview()
            
            let imageName = thisUser.avatar != "" ? thisUser.avatar : "Rectangle.png"
            self.avatarImage = UIImageView(image:UIImage(named:imageName))
            
            self.avatarImage.layer.cornerRadius = 9.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).cgColor
            self.avatarImage.layer.borderWidth = 1.0
            
            let avatarX =  (type == ChatType.someone) ? 2 : self.frame.size.width - 52

            let avatarY =  height
            //set the frame correctly
            self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 50, height: 50)
            self.addSubview(self.avatarImage)
            
            let delta =  self.frame.size.height - (self.msgItem.insets.top
                + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height)
            if (delta > 0) {
                y = delta
            }
            if (type == ChatType.someone) {
                x += 54
            }
            if (type == ChatType.mine) {
                x -= 54
            }
        }
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRect(x: x + self.msgItem.insets.left,
                                       y: y + self.msgItem.insets.top, width: width, height: height)
        
        self.addSubview(self.customView)
        
        if (type == ChatType.someone)
        {
            self.bubbleImage.image = UIImage(named:("Rectangle.png"))!
                .stretchableImage(withLeftCapWidth: 21,topCapHeight:14)
            
        }
        else {
            self.bubbleImage.image = UIImage(named:"Rectangle.png")!
                .stretchableImage(withLeftCapWidth: 15, topCapHeight:14)
        }
        self.bubbleImage.frame = CGRect(x: x, y: y,
                                        width: width + self.msgItem.insets.left + self.msgItem.insets.right,
                                        height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
}
