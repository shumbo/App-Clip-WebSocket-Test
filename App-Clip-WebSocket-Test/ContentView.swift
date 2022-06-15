//
//  ContentView.swift
//  App-Clip-WebSocket-Test
//
//  Created by Shun Kashiwa on 2022/06/15.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    private var model = ContentViewModel()
    
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

class ContentViewModel: ObservableObject {
    @Published
    var message: String = "no message yet"
    
    private var webSocketTask: URLSessionWebSocketTask?
    // MARK: - Connection
    func connect() { // 2
        let url = URL(string: "ws://127.0.0.1:8080")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        if case .success(let message) = incoming {
            onMessage(message: message)
        } else {
            print("onReceive failed")
        }
        
    }
    
    private func onMessage(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            print("received", text)
            DispatchQueue.main.async {
                self.message = text
            }
        } else {
            print("received non-string data")
        }
    }
    
    deinit { // 9
        disconnect()
    }
}
