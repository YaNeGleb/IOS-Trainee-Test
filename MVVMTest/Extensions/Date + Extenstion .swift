import Foundation

extension Date {
    static func dateString(fromTimestamp intTimestamp: Int) -> String {
        let timestamp: TimeInterval = TimeInterval(intTimestamp)
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}






