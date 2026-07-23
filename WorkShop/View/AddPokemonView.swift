import SwiftUI
import Nuvem

struct AddPokemonView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var trainer: Trainer.Observable
    
    @State private var name: String = ""
    @State private var type: String = "Normal"
    
    let types = ["Normal", "Fire", "Water", "Grass", "Electric"]
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Name"){
                    TextField("Type the pokémon name", text: $name)
                }
                Section("Type"){
                    Picker("Pokémon type", selection: $type){
                        ForEach(types, id: \.self){
                            Text($0)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button(role: .cancel){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button(role: .confirm) {
                        savePokemon()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add Pokémon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func savePokemon() {
        
        Task{
            let shinyChance = Int.random(in: 1...100)
            let isShiny = shinyChance <= 20
            
            var newPokemon = Pokemon(name: name, type: type, isShiny: isShiny, trainer: trainer.model)
            do{
                try await newPokemon.save(on: .private)
                
                trainer.pokemons.append(newPokemon)
                
                try await trainer.save(on: .private)
            } catch{
                print(error)
            }
            dismiss()
        }
    }
}

//#Preview {
//    AddItemView()
//}
