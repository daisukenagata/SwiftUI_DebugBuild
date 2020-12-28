//
//  ContentView.swift
//  SwiftUI_DebugBuild
//
//  Created by 永田大祐 on 2020/12/28.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var c = CheckBuild()

    init(c: CheckBuild? = nil) {

        self.c = c ?? CheckBuild()
    }

    var body: some View {

        VStack {
            Text(c.statusCode.description)
            Text(c.count.description)
            Text(c.os)
            Text(c.uuidSet)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
