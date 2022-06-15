//
//  SocketViewModel.swift
//  App-Clip-WebSocket-Test
//
//  Created by Shun Kashiwa on 2022/06/15.
//

import SwiftUI

class SocketViewModel: ObservableObject {
    @Published
    var message: String = "no message yet"
    
    private var webSocketTask: URLSessionWebSocketTask?
    // MARK: - Connection
    func connect() { // 2
        let url = URL(string: "wss://080f-2600-1700-87f0-6de0-9199-8309-2cbe-308d.ngrok.io")!
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
        } else if case .failure(let error) = incoming {
            print("onReceive failed", error)
        } else {
            print("onReceive failed with other reasons")
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
    
    deinit {
        disconnect()
    }
}
