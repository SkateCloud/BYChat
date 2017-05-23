import UIKit

class ViewController: UIViewController, ChatDataSource,UITextFieldDelegate {
    
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatTable()
        setupSendPanel()
    }
    
    func setupSendPanel()
    {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        
        sendView.backgroundColor=UIColor.lightGray
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor=UIColor(red: 0x37/255, green: 0xba/255, blue: 0x46/255, alpha: 1)
        sendButton.addTarget(self, action:#selector(ViewController.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    func sendMessage()
    {
        //composing=false
        let sender = txtMsg
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
        let thatChat =  MessageItem(body:"我要学你说话：\(sender!.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
        
        Chats.add(thisChat)
        Chats.add(thatChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
        sender?.resignFirstResponder()
        sender?.text = ""
    }
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 76), style: .plain)

        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"skate" ,logo:("cloud.jpg"))
        you  = UserInfo(name:"cloud", logo:("cloud.jpg"))
        
        let zero =  MessageItem(body:"hello", user:you,  date:Date(timeIntervalSinceNow:-90096400), mtype:.someone)
        
        let zero1 =  MessageItem(body:"hi", user:me,  date:Date(timeIntervalSinceNow:-90086400), mtype:.mine)
        
        let first =  MessageItem(body:"how ere you", user:me,  date:Date(timeIntervalSinceNow:-90000600), mtype:.mine)
        
        let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        
        let third =  MessageItem(body:"yes",user:you, date:Date(timeIntervalSinceNow:-90000060), mtype:.someone)
        
        let fouth =  MessageItem(body:"No",user:me, date:Date(timeIntervalSinceNow:-90000020), mtype:.mine)
        
        let fifth =  MessageItem(body:"Ok",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        
        Chats = NSMutableArray()
        Chats.addObjects(from: [first,second, third, fouth, fifth, zero, zero1])
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



