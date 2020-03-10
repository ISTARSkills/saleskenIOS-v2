//
//  Socket.swift
//  Salesken
//
//  Created by Anup on 09/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//
import Foundation
import Starscream
class Socket: NSObject, WebSocketDelegate{
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            writeString(data: "Hi this is Anup soni")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received binary data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    var socket: WebSocket!
    var isConnected = false
    
    static let instance = Socket()
    private override init(){
        super.init()
        var request = URLRequest(url: URL(string: Constants.SOCKET_URL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func connect(){
        if !isConnected{
            socket.connect()
        }
    }
    func disconnect(){
        if isConnected{
            socket.disconnect()
        }
    }
    func writeBinary(data: Data){
        if isConnected{
            socket.write(data: data)
            print("send audio data ",data)
        }
        
    }
    func writeString(data: String){
        if isConnected{
            socket.write(string: data)
            print("send data ",data)
        }
        
    }
}
