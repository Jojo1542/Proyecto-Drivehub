//
//  PreviewHelper.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation

class PreviewHelper {
    
    private static var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoiYWRtaW5Aam9qbzE1NDIuZXMiLCJpYXQiOjE3MTcwMTA3NzIsImV4cCI6MTcxNzA5NzE3Mn0.7XlTP8BopCycbqlIJGrVBfot-Iahe7KX-t8etKavBB8tw8pL6r8cErUUD3Dc8yEj1LNSR4W3meHaKX2Mha3cuQ";
    
    static var activeUserRentHistoryModel: UserRentHistoryModel {
        return UserRentHistoryModel(
            user: authModelUser.currentUser!,
            vehicle: rentCar1,
            startTime: Date.now.addingTimeInterval(-3643),
            active: false
        )
    }
    
    static var finishedUserHistoryModel: UserRentHistoryModel {
        return UserRentHistoryModel(
            user: authModelUser.currentUser!,
            vehicle: rentCar1,
            startTime: Date.now.addingTimeInterval(-86400),
            endTime: Date.now.addingTimeInterval(-3600),
            active: false,
            finalPrice: 10.0
        )
    }
    
    static var authModelUser: AuthViewModel {
        let viewModel = AuthViewModel()
        
        //viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.sessionToken = token;
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            balance: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER],
            driverLicenses: [
                UserModel.DriverLicense(
                    licenseNumber: "AAA-AAA-AAA-AAA",
                    type: UserModel.DriverLicense.DriverLicenseType.B,
                    expirationDate: Date.now.addingTimeInterval(86400),
                    issueDate: Date.now.addingTimeInterval(-86400)
                )
            ],
            balanceHistory: [
                UserModel.BalanceHistory(id: 1, type: .DEPOSIT, amount: 10.0, date: Date.now.addingTimeInterval(-86400)),
                UserModel.BalanceHistory(id: 2, type: .WITHDRAW, amount: 1.0, date: Date.now.addingTimeInterval(-7200)),
                UserModel.BalanceHistory(id: 3, type: .DEPOSIT, amount: 2.0, date: Date.now.addingTimeInterval(-3600)),
                UserModel.BalanceHistory(id: 4, type: .WITHDRAW, amount: 3.0, date: Date.now.addingTimeInterval(-1800)),
                UserModel.BalanceHistory(id: 5, type: .WITHDRAW, amount: 4.0, date: Date.now.addingTimeInterval(-1)),
            ]
        );
        
        return viewModel
    }
    
    static var authModelUserNotConfirmedDNI: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            balance: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER],
            driverLicenses: []
        );
        
        return viewModel
    }
    
    static var authModelAdmin: AuthViewModel {
        let viewModel = AuthViewModel()
        
        //viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.sessionToken = token;
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            balance: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.ADMIN],
            adminData: UserModel.AdminData(
                avaiableTime: "08:00-20:00",
                generalPermissions: UserModel.AdminData.AdminPermission.allCases,
                fleetPermissions: [1]
            ),
            driverLicenses: []
        );
        
        return viewModel
    }
    
    static var authModelFleetDriver: AuthViewModel {
        let viewModel = AuthViewModel()
        
        //viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.sessionToken = token;
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            balance: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.FLEET],
            driverData: UserModel.DriverData(
                avaiableTime: "08:00-20:00",
                maxTonnage: 12,
                fleet: 1
            ),
            driverLicenses: [
                UserModel.DriverLicense(
                    licenseNumber: "AAAAA-1",
                    type: UserModel.DriverLicense.DriverLicenseType.B,
                    expirationDate: Date(),
                    issueDate: Date()
                )
            ]
        );
        
        return viewModel
    }
    
    static var authModelChaoffeur: AuthViewModel {
        let viewModel = AuthViewModel()
        
        //viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.sessionToken = token;
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            balance: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.CHAUFFEUR],
            driverData: UserModel.DriverData(
                avaiableTime: "08:00-20:00",
                preferedDistance: 10.0,
                canTakePassengers: false,
                vehicleModel: "Modelo",
                vehiclePlate: "1234ABC",
                vehicleColor: "Rojo"
            ),
            driverLicenses: [
                UserModel.DriverLicense(
                    licenseNumber: "AAAAA-1",
                    type: UserModel.DriverLicense.DriverLicenseType.B,
                    expirationDate: Date(),
                    issueDate: Date()
                ),
                UserModel.DriverLicense(
                    licenseNumber: "AAAAB-2",
                    type: UserModel.DriverLicense.DriverLicenseType.A2,
                    expirationDate: Date(),
                    issueDate: Date()
                )
            ]
        );
        
        return viewModel
    }
    
    static var pendingTrip: TripModel {
        return TripModel(
            id: 1,
            status: TripModel.Status.PENDING,
            date: Date(timeIntervalSince1970: 1672531200), // 25/04/2024
            startTime: Date(timeIntervalSince1970: 1672531200), // 12:00
            endTime: nil,
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: nil,
            passenger: authModelUser.currentUser!
        )
    }
    
    static var finishedTrip: TripModel {
        return TripModel(
            id: 2,
            status: TripModel.Status.FINISHED,
            date: Date(timeIntervalSince1970: 1672531200), // 25/04/2024
            startTime: Date(timeIntervalSince1970: 1672531200), // 12:00
            endTime: Date(timeIntervalSince1970: 1672533000), // 13:30
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: exampleDriverTrip,
            passenger: authModelUser.currentUser!,
            vehicleModel: "Toyota Corolla",
            vehiclePlate: "1111AAA",
            vehicleColor: "Rojo"
        )
    }
    
    static var acceptedTrip: TripModel {
        return TripModel(
            id: 3,
            status: TripModel.Status.ACCEPTED,
            date: Date(timeIntervalSince1970: 1672531200), // 25/04/2024
            startTime: Date(timeIntervalSince1970: 1672531200), // 12:00
            endTime: nil,
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: exampleDriverTrip,
            passenger: authModelUser.currentUser!,
            vehicleModel: "Toyota Corolla",
            vehiclePlate: "1111AAA",
            vehicleColor: "Rojo"
        )
    }
    
    static var rentCar1: RentCarModel {
        return RentCarModel(
            id: 1,
            plate: "1234ABC",
            numBastidor: "123456789",
            brand: "Seat",
            model: "Ibiza",
            color: "Rojo",
            fechaMatriculacion: Date.now.addingTimeInterval(-120000),
            imageUrl: "https://www.surmocion.com/wp-content/uploads/2023/04/SEAT-Ibiza-estática-frontal-1.jpg",
            precioHora: 10.0,
            available: true
        )
    }
    
    static var exampleShipment: ShipmentModel {
        return ShipmentModel(
            id: 1,
            sourceAddress: "Calle Solidaridad, 50, 41006, Sevilla",
            destinationAddress: "Calle Serenidad, 42A, 41006",
            shipmentDate: Date.now.addingTimeInterval(-10000),
            deliveryDate: Date.now.addingTimeInterval(36000),
            hidden: false,
            actualStatus: ShipmentModel.StatusHistory.StatusType.DELAYED,
            statusHistory: [
                ShipmentModel.StatusHistory(
                        id: 1,
                        updateDate: Date(timeIntervalSince1970: 1716146421),
                        status: ShipmentModel.StatusHistory.StatusType.PENDING_TO_PICK_UP,
                        description: "Su envio ha sido registrado y está pendiente de recogida en la dirección de origen."
                    ),
                    ShipmentModel.StatusHistory(
                        id: 2,
                        updateDate: Date(timeIntervalSince1970: 1716146460),
                        status: ShipmentModel.StatusHistory.StatusType.IN_TRANSIT,
                        description: nil
                    ),
                    ShipmentModel.StatusHistory(
                        id: 3,
                        updateDate: Date(timeIntervalSince1970: 1716146511),
                        status: ShipmentModel.StatusHistory.StatusType.DELAYED,
                        description: "Su envio ha tenido un problema por lo cual ha sido retrasado."
                    )
            ],
            parcels: [
                ShipmentModel.Parcel(id: 1, content: "PS5", quantity: 1, weight: 5.0),
                ShipmentModel.Parcel(id: 2, content: "Xbox Series X", quantity: 5, weight: 6.0),
                ShipmentModel.Parcel(id: 3, content: "Nintendo Switch", quantity: 3, weight: 3.0)
            ],
            driver: ShipmentModel.ShipmentDriver(
                id: 1,
                firstName: "José Antonio",
                lastName: "Ponce Piñero",
                birthDate: Date(timeIntervalSince1970: 1716146421),
                dni: "12345678Z",
                phone: "+34-666666666"
            )
        )
    }
    
    static var exampleFleet: FleetModel {
        return FleetModel(id: 1, name: "Fleet 1", cif: "12345678A", vehicleType: .VAN);
    }
    
    static var exampleDriverTrip: TripModel.DriverInfo {
        return TripModel.DriverInfo(
            id: 1, firstName: "Nombre", lastName: "Apellidos", dni: "11111111A", birthDate: Date(timeIntervalSince1970: 1716146421)
        )
    }
    
}
