//
//  TripsViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation
import CoreLocation
import SwiftUI

class TripsViewModel: ObservableObject {
    
    var appModel: AppViewModel;
    private var locationService: LocationService;
    private var statusListener: SseService<NetworkListeners.TripUpdateMessage>;
    private var locationListener: SseService<UserLocationModel>;
    
    @Published var activeTrip: TripModel?;
    @Published var activeTripStatus: TripModel.Status = .PENDING
    @Published var driverLocation: CLLocationCoordinate2D?;
    
    var sessionToken: String {
        return self.appModel.getSessionToken();
    }
    
    public init(appModel: AppViewModel) {
        self.appModel = appModel;
        self.locationService = LocationService(background: false);
        self.locationService.startUpdatingLocation();
        
        self.statusListener = NetworkListeners.getTripStatusListener(sessionToken: self.appModel.getSessionToken());
        self.locationListener = NetworkListeners.getDriverLocationListener(sessionToken: self.appModel.getSessionToken());
    }
    
    public func refreshActiveTrip() {
        GetActiveTripRequest.getActiveTrip(sessionToken: sessionToken) { result in
            switch result {
                case .success(let data):
                    self.activeTrip = data!;
                    self.activeTripStatus = data!.status;
                case .failure(let error):
                    if error == 404 {
                        self.activeTrip = nil;
                    } else {
                        print("Error getting active trip: \(error!)");
                    }
            }
        }
    }
    
    public func getLastLocation() -> CLLocation? {
        return self.locationService.getLastLocation();
    }

    
    public func createDraft(data: CreateTripDraftRequest.RequestBody, completion: @escaping (Callback<TripDraftModel, CreateTripDraftRequest.ErrorType>) -> Void) {
        CreateTripDraftRequest.createTripDraft(sessionToken: sessionToken, data: data) { result in
            switch result {
                case .success(let data):
                    completion(.success(data: data!));
                case .failure(let error):
                    completion(.failure(data: error));
            }
        }
    }
    
    public func startTrip(draft: TripDraftModel, sendPackage: Bool, completion: @escaping (Callback<Void, CreateTripRequest.ErrorType>) -> Void) {
        CreateTripRequest.startTrip(sessionToken: sessionToken, draftId: draft.id, sendPackage: sendPackage) { result in
            switch result {
                case .success(_):
                    self.refreshActiveTrip();
                    self.startTripStatusListener(); // Empezar a escuchar cambios en el estado del viaje
                    completion(.success());
                
                    // Wait 1 second and refresh again
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.refreshActiveTrip();
                    }
                case .failure(let error):
                    completion(.failure(data: error));
            }
        }
    }
    
    // Cancel Trip
    public func cancelTrip(completion: @escaping (Callback<Void, Int>) -> Void) {
        CancelTripRequest.cancelTrip(sessionToken: sessionToken) { result in
            switch result {
                case .success(_):
                    self.refreshActiveTrip();
                    completion(.success());
                case .failure(let error):
                    completion(.failure(data: error));
            }
        }
    }
    
    private func startTripStatusListener() {
        self.statusListener.onMessage { message in
            print("Received update message: \(message)");
            
            // Mensajes customizados sobre estados
            if (message.status == .CANCELLED_DUE_TO_NO_DRIVER) {
                showDialog(title: "Viaje cancelado", description: "El viaje ha sido cancelado debido a que no se ha encontrado un conductor disponible");
            } else if (message.status == .FINISHED) {
                showDialog(title: "Viaje finalizado", description: "El viaje ha finalizado con éxito.");
            } else if (message.status == .ACCEPTED) {
                // Cuando ha sido aceptado, se empieza a escuchar la ubicación del conductor
                // Esperamos 2 segundos para dar tiempo a que el conductor se mueva
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.startLocationListener();
                }
            }
            
            // Actualizar el viaje activo
            withAnimation(.linear(duration: 0.5)) {
                self.refreshActiveTrip();
            }
        }
        
        self.statusListener.connect();
    }
    
    private func startLocationListener() {
        self.locationListener.onMessage { location in
            
            withAnimation(.linear(duration: 0.5)) {
                self.driverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude);
            }
        }
        
        self.locationListener.connect();
    }
}
