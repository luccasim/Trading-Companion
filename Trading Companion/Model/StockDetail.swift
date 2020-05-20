import Foundation

struct StockMatch : Codable {
    
    let matches : [StockDetail]
    
    enum CodingKeys : String, CodingKey {
        case matches = "bestMatches"
    }
}

struct StockDetail : Codable {
    
    let symbol  : String
    let name    : String
    let type    : String
    let region  : String
    
}

extension StockDetail {
    
    enum CodingKeys : String, CodingKey {
        case symbol = "1. symbol"
        case name   = "2. name"
        case type   = "3. type"
        case region = "4. region"
    }
}

extension StockDetail {
    
    enum Errors : Error {
        case noMatchesfound
    }
}

extension StockDetail {
    
    /// Create the first matching details from the request
    /// - Parameter FromData: Data received
    /// - Throws: JsonDecoding, and not matching found.
    init(FromData:Data) throws {
        
        let decoder = JSONDecoder()
        let matches = try decoder.decode(StockMatch.self, from: FromData)
        
        guard let first = matches.matches.first else {
            throw Errors.noMatchesfound
        }
        
        self = first
    }

}
