//
//  ContentView.swift
//  SwiftUI_DebugBuild
//
//  Created by 永田大祐 on 2020/12/28.
//

import SwiftUI
import Combine

struct ContentView: View {

    @State var returnRes = [""]
    @ObservedObject var c = CheckBuild()

    var body: some View {

        VStack {
        Text(c.statusCode.description)
        Text(c.count.description)
        Text(c.os)
        Text(c.uuidSet)
        }
        .onAppear {
            read()
        }
    }

    func read() {
        
        if let urls = Bundle.main.path(forResource: "uuid", ofType:"plist" ) {
            let plist = NSDictionary(contentsOfFile: urls) as? Dictionary<String, String>
            c.res(treturnRes: returnRes, uuid: plist?["uuid"] ?? "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


final class CheckBuild: ObservableObject {

    @Published var statusCode: Int = 0
    @Published var count: String = ""
    @Published var os: String = ""
    @Published var uuidSet: String = ""

    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    func res(treturnRes: [String], uuid: String) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/HH"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.calendar = Calendar(identifier: .gregorian)

        let now = Date()
        let date = formatter.string(from: now)
        let d:[String] = date.description.components(separatedBy: "/")

        let myURL = "https://7tslpj7nwg.execute-api.ap-northeast-1.amazonaws.com/default/DateTime?year=\(d[0])&month=\( d[1])&day=\(d[2])&hour=\(d[3])&os=\(UIDevice.current.systemVersion.description)&uuid=\(uuid)"

        let encodeUrlString: String = myURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: encodeUrlString) else { return }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Time.self, decoder: JSONDecoder())
            .map { $0 }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }, receiveValue: { [self] user in
            statusCode = user.statusCode
            count = user.count
            os = user.os
            uuidSet = user.uuid
        })
    }
}
