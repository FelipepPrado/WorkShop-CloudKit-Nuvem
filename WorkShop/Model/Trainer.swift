import Nuvem
import CloudKit

@CKModel
struct Trainer{
    @CKField("name", default: "Trainer Name")
    var name: String
    
    @CKField("age", default: 1)
    var age: Int
    
    @CKReferenceListField("pokemons", default: [])
    var pokemons: [Pokemon]
    
    init(name: String, age: Int, pokemons: [Pokemon] = []) {
        self.name = name
        self.age = age
        self.pokemons = pokemons
    }
}
