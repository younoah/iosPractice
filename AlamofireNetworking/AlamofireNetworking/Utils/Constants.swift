//
//  Constants.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/10/30.
//

import Foundation

enum SegueID {
    static let userListVC = "goToUserList"
    static let photoCollectionVC = "goToPhotoCollection"
}

enum API {
    static let baseURL = "https://api.unsplash.com/"
    static let clientID = "y-CAq7Z6baxHZCBXIKcl4viZCs15sAUavmXGW1on_Gc"
    
}

enum Notification {
    enum API {
        static let AuthFail = "authentication_fail"
    }
}
