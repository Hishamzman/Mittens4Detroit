//
//  MittensForDetroitApp.swift
//  MittensForDetroit
//
//  Created by MohamedSafaoui on 1/24/23.
//

import SwiftUI

@main
struct MittensForDetroitApp: App {
    var body: some Scene {
        WindowGroup {
           LoadingScreen().environmentObject(TitleTest())
         //  CloudKitBootcamp()
            
            
        }
    }
}
