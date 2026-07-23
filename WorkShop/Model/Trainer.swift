import Nuvem
import CloudKit

@CKModel
struct Trainer{
    @CKField("name", default: "Trainer Name")
    var name: String
    
    @CKField("age", default: Date())
    var age: Date
    
    @CKReferenceListField("pokemons", default: [])
    var pokemons: [Pokemon]
    
    init(name: String, age: Date, pokemons: [Pokemon] = []) {
        self.name = name
        self.age = age
        self.pokemons = pokemons
    }
}
