//
//  CloudKitBootcamp.swift
//  MittensForDetroit
//
//  Created by MohamedSafaoui on 2/8/23.
//

import SwiftUI
import CloudKit

class CloudKitBootcamps: ObservableObject{
    
    let container = CKContainer(identifier: "iCloud.MittensForDetroit")
   
    @Published var issignedintoicloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var permissionstatus: Bool = false
    
    init() {
        getiCloudStatus()
        requestpermission()
        fetchiCloudUserRecoredID()
    }
    private func getiCloudStatus(){
        container.accountStatus { returnedStatus, returnedError in DispatchQueue.main.async {
            switch returnedStatus {
            case .available:
                self.issignedintoicloud = true
                break
            case .noAccount:
                self.error = CloudKitError.icloudAccountNotFound.rawValue
                break
            case .couldNotDetermine:
                self.error = CloudKitError.icloudAccountNotDetermined.rawValue
                break
            case .restricted:
                self.error = CloudKitError.icloudAccountRestricted.rawValue
                break
            default:
                self.error = CloudKitError.icloudAccountUnkown.rawValue
                
                break
            }
        }
    }
}
    
    enum CloudKitError: String, LocalizedError {
        case icloudAccountNotFound
        case icloudAccountNotDetermined
        case icloudAccountRestricted
        case icloudAccountUnkown
    }
    
    func fetchiCloudUserRecoredID() {
        container.fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    
    
    func requestpermission() {
        container.requestApplicationPermission([.userDiscoverability]) { [weak self] returnedstatus, returnedError in
            DispatchQueue.main.async {
                if returnedstatus == .granted{
                    self?.permissionstatus = true
                }
            }
        }
    }
    
    func discoveriCloudUser(id: CKRecord.ID) {
      container.discoverUserIdentity(withUserRecordID: id) {[weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName{
                    
                    self?.userName = name
                   
                }
            }
        }
    }
    
}


struct CloudKitBootcamp: View {
    

    @StateObject private var vm = CloudKitBootcamps()
  
    var body: some View {
        VStack {
            
            
            Text("is signed in: !\(vm.issignedintoicloud.description.uppercased())")
            Text(vm.error)
            Text("permission: \(vm.permissionstatus.description.uppercased())")
            Text("name: \(vm.userName)")
            
        }
    }
}

struct CloudKitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitBootcamp()
    }
}
