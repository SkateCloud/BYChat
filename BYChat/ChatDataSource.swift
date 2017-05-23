import Foundation

protocol ChatDataSource
{
    func rowsForChatTable( _ tableView:TableView) -> Int
    func chatTableView(_ tableView:TableView, dataForRow:Int)-> MessageItem
}
