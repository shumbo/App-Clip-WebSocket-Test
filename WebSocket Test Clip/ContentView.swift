//
//  ContentView.swift
//  WebSocket Test Clip
//
//  Created by Shun Kashiwa on 2022/06/15.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    private var model = SocketViewModel()
    
    var body: some View {
        Text(model.message)
            .padding().onAppear(perform: {
                print("onAppear")
                model.connect()
            }).onDisappear(perform: {
                print("onDisappear")
                model.disconnect()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
