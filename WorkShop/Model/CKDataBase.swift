import CloudKit

//Tipos do Database do CloudKit
extension CKDatabase{
    static let `public` = CKContainer(
        identifier: "iCloud.com.WorkShopCloudKit.WorkShop"
    )
    .publicCloudDatabase
    
    static let `private` = CKContainer(
        identifier: "iCloud.com.WorkShopCloudKit.WorkShop"
    )
    .privateCloudDatabase
    
    static let `shared` = CKContainer(
        identifier: "iCloud.com.WorkShopCloudKit.WorkShop"
    )
    .sharedCloudDatabase
}

