import UIKit

enum ChatBubbleTypingType
{
    case nobody
    case me
    case somebody
}

class TableView:UITableView,UITableViewDelegate, UITableViewDataSource
{

    var bubbleSection:NSMutableArray!
    var chatDataSource:ChatDataSource!
    
    var  snapInterval:TimeInterval!
    var  typingBubble:ChatBubbleTypingType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        //the snap interval in seconds implements a headerview to seperate chats
        self.snapInterval = TimeInterval(60 * 60 * 24) //one day
        self.typingBubble = ChatBubbleTypingType.nobody
        self.bubbleSection = NSMutableArray()
        
        super.init(frame:frame,  style:style)
        
        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.delegate = self
        self.dataSource = self
    }
    
    override func reloadData()
    {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        var count =  0
        if ((self.chatDataSource != nil))
        {
            count = self.chatDataSource.rowsForChatTable(self)
            
            if(count > 0)
            {
                let bubbleData =  NSMutableArray(capacity:count)
                
                for i in 0 ..< count
                {
                    let object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    bubbleData.add(object)
                }
                bubbleData.sort(comparator: sortDate)
                
                var last =  ""
                
                var currentSection = NSMutableArray()
                let dformatter = DateFormatter()
                dformatter.dateFormat = "dd"
                
                for i in 0 ..< count
                {
                    let data =  bubbleData[i] as! MessageItem
                    let datestr = dformatter.string(from: data.date as Date)
                    if (datestr != last)
                    {
                        currentSection = NSMutableArray()
                        self.bubbleSection.add(currentSection)
                    }
                    (self.bubbleSection[self.bubbleSection.count-1] as AnyObject).add(data)
                    
                    last = datestr
                }
            }
        }
        super.reloadData()
        
        let secno = self.bubbleSection.count - 1
        let indexPath =  IndexPath(row:(self.bubbleSection[secno] as AnyObject).count,section:secno)
        
        self.scrollToRow(at: indexPath,                at:UITableViewScrollPosition.bottom,animated:true)
    }
    
    func sortDate(_ m1: Any, m2: Any) -> ComparisonResult {
        if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970)
        {
            return ComparisonResult.orderedAscending
        }
        else
        {
            return ComparisonResult.orderedDescending
        }
    }
    
    func numberOfSections(in tableView:UITableView)->Int {
        var result = self.bubbleSection.count
        if (self.typingBubble != ChatBubbleTypingType.nobody)
        {
            result += 1;
        }
        return result;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return (self.bubbleSection[section] as AnyObject).count+1
    }
    
    func tableView(_ tableView:UITableView,heightForRowAt indexPath:IndexPath)
        -> CGFloat {
            // Header
            if (indexPath.row == 0)
            {
                return TableHeaderViewCell.getHeight()
            }
            let section  =  self.bubbleSection[indexPath.section] as! NSMutableArray
            let data = section[indexPath.row - 1]
            
            let item =  data as! MessageItem
            let height  = item.insets.top + max(item.view.frame.size.height , 52) + item.insets.bottom
            print("height:\(height)")
            return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            // Header based on snapInterval
            if (indexPath.row == 0)
            {
                let cellId = "HeaderCell"
                
                let hcell =  TableHeaderViewCell(reuseIdentifier:cellId)
                let section =  self.bubbleSection[indexPath.section] as! NSMutableArray
                let data = section[indexPath.row] as! MessageItem
                
                hcell.setDate(data.date)
                return hcell
            }
            // Standard
            let cellId = "ChatCell"
            
            let section =  self.bubbleSection[indexPath.section] as! NSMutableArray
            let data = section[indexPath.row - 1]
            
            let cell =  TableViewCell(data:data as! MessageItem, reuseIdentifier:cellId)
            
            return cell
    }
}
