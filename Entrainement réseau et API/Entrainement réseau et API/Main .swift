import Foundation

class QuoteService {
    static var shared = QuoteService()
    private init() {}
    
    private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!

    private var task: URLSessionDataTask?
    private var quoteSession = URLSession(configuration: .default)
    private var imageSession = URLSession(configuration: .default)
    
    init(quoteSession: URLSession, imageSession: URLSession){
        self.quoteSession = quoteSession
        self.imageSession = imageSession
    }
    
    func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        let request = QuoteService.createQuoteRequest()

        task?.cancel()
        task = quoteSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    let text = responseJSON["quoteText"],
                    let author = responseJSON["quoteAuthor"] else {
                        callback(false, nil)
                        return
                }

                self.getImage { (data) in
                    guard let data = data else {
                        callback(false, nil)
                        return
                    }

                    let quote = Quote(text: text, author: author, imageData: data)
                    callback(true, quote)
                }
            }
        }
        task?.resume()
    }


    private static func createQuoteRequest() -> URLRequest {
        var request = URLRequest(url: QuoteService.quoteUrl)
        request.httpMethod = "POST"

        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        task?.cancel()
        task = imageSession.dataTask(with: QuoteService.pictureUrl) { (data, response, error) in
            DispatchQueue.main.sync {
                guard let data = data, error == nil else{
                    completionHandler(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                    completionHandler(nil)
                    return
                    }
            completionHandler(data)
            }
        }
        task?.resume()
    }
}
