//
//  SseService.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/5/24.
//

import Foundation
import EventSource

class SseService<T: Decodable> {
    
    var callback: ((T) -> Void)?
    var eventSource: EventSource?
    var sessionToken: String
    var lastKeepAlive: Date?
    var timer: Timer?
    
    public init(type: SseUrl, sessionToken: String) {
        let url = URL(string: "\(NetworkConfiguration.baseUrl)\(type.rawValue)")!
    
        self.sessionToken = sessionToken
        
        eventSource = EventSource(url: url, headers: ["Authorization": "Bearer \(sessionToken)"])
        
        print("Creando servicio \(url)")
        
        // Evento por defecto de abrir la conexión
        eventSource?.onOpen {
            print("Conexión establecida a \(url)")
        }
        
        eventSource?.addEventListener("keep-alive", handler: { id, event, data in
            print("Keep-alive recibido para \(url)")
            self.lastKeepAlive = Date()
        })
        
        // Se envía un KeepAlive cada 10 segundos, si no se recibe se reconecta
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            if let lastKeepAlive = self.lastKeepAlive {
                let seconds = Date().timeIntervalSince(lastKeepAlive)
                if seconds > 10 {
                    print("Se ha perdido la conexión con el stream \(url) reconectando...")
                    self.connect()
                }
            }
        }
    }
    
    enum SseUrl: String {
        case DRIVER_LOCATION = "/trip/stream/location"
        case TRIP_STATUS = "/trip/stream/status"
        case DUTY = "/trip/stream/duty"
    }
    
    public func connect() {
        print("Conectando a \(eventSource!.url)")
        eventSource?.connect()
    }
    
    public func disconnect() {
        print("Desconectando de \(eventSource!.url)")
        eventSource?.disconnect()
    }
    
    public func onMessage(callback: @escaping (T) -> Void) {
        eventSource?.onMessage { (id, event, data) in
            guard let dataString = data, let data = dataString.data(using: .utf8) else {
                print("No se ha podido convertir el mensaje a String")
                return
            }
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                callback(decodedData)
            } catch {
                print("Error al decodificar el mensaje, el error es: \(error)")
            }
        }
    }
    
    public func onOpen(callback: @escaping () -> Void) {
        eventSource?.onOpen(callback)
    }
    
    public func onComplete(callback: @escaping (Bool) -> Void) {
        eventSource?.onComplete { statusCode, reconnect, error in
            if let error = error {
                print("Error al conectar con el servidor: \(error)")
            }
            
            print("Conexión completada con código \(statusCode ?? 0)")
            
            callback(reconnect ?? false)
            
            guard reconnect ?? false else {
                return
            }
            
            let retryTime = self.eventSource?.retryTime ?? 3_000 // 3 segundos si no se ha especificado
            
            // Reconectar después de un tiempo
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) {
                self.eventSource?.connect()
            }
        }
    }
    
    deinit {
        print("Destruyendo servicio \(eventSource!.url)")
        eventSource?.disconnect()
    }
}
