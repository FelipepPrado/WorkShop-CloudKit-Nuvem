import Nuvem
import SwiftUI
import CloudKit

@CKModel
struct Pokemon{
    @CKField("name", default: "Pokemon Name")
    var name: String
    
    @CKField("type", default: "Normal")
    var type: String
    
    @CKField("isShiny", default: false)
    var isShiny: Bool
    
    @CKReferenceField("trainer", action: .deleteSelf)
    var trainer: Trainer?
    
    init(name: String, type: String = "Normal", isShiny: Bool = false, trainer: Trainer? = nil) {
        self.name = name
        self.type = type
        self.isShiny = isShiny
        self.trainer = trainer
    }
}
