//
//  AboutAppView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct AboutAppView: View {
    
    @State var appVersion: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Información de la aplicación").font(.title3).bold()) {
                HStack {
                    Text("Versión")
                    Spacer()
                    Text("\(appVersion)")
                        .onTapGesture {
                            UIPasteboard.general.string = appVersion
                            if (appVersion == getBuildNumber()) {
                                appVersion = getAppVersion()
                            } else {
                                appVersion = getBuildNumber()
                            }
                        }
                        .onAppear {
                            appVersion = getAppVersion()
                        }
                }
                
                HStack {
                    Text("Fecha de compilación")
                    Spacer()
                    Text("\(getBuildDate())")
                }
                
                HStack {
                    Text("Desarrollador")
                    Spacer()
                    Text("Jose Antonio Ponce Piñero")
                }
                
                HStack {
                    Text("Contacto")
                    Spacer()
                    Text("jponpin0212@iesmartinezm.es")
                }
                
                /*HStack {
                    Text("Backend")
                    Spacer()
                    Text("\(NetworkConfiguration.baseUrl)")
                }.onTapGesture {
                    UIPasteboard.general.string = NetworkConfiguration.baseUrl
                }*/
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Sobre la aplicación")
    }
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }

    func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }
    
    // Get build date
    func getBuildDate() -> String {
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
           let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date {
            return infoDate.formatted()
        }
        return "Unknown"
    }
}

#Preview {
    AboutAppView()
}
