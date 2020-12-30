//
//  CheckBuild.swift
//  SwiftUI_DebugBuild
//
//  Created by 永田大祐 on 2020/12/29.
//

import SwiftUI
import Combine

final class CheckBuild: ObservableObject {

    @Published var statusCode: Int = 0
    @Published var count: String = ""
    @Published var os: String = ""
    @Published var uuidSet: String = ""

    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    func res(treturnRes: [String], uuid: String) {

        let myURL = "https://7tslpj7nwg.execute-api.ap-northeast-1.amazonaws.com/default/DateTime?&os=\(UIDevice.current.systemVersion.description)&uuid=\(uuid)&type=ios"

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

