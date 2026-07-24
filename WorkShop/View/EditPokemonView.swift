import SwiftUI
import Nuvem

struct EditPokemonView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var trainer: Trainer.Observable
    @Bindable var pokemon: Pokemon.Observable
    
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
                        updatePokemon()
                    }
                    .disabled(name.isEmpty || (pokemon.name == name && pokemon.type == type))
                }
            }
            .navigationTitle("Add Pokémon")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            name = pokemon.name
            type = pokemon.type
        }
    }
    
    func updatePokemon() {
        Task{
            let editPokemon = pokemon
            editPokemon.name = name
            editPokemon.type = type
            
            do{
                try await editPokemon.save(on: .private)
                
                if let index = trainer.pokemons.firstIndex(where: { $0.id == editPokemon.id }) {
                    trainer.pokemons[index] = editPokemon.model
                }
            } catch{
                print(error)
            }
            
            dismiss()
        }
    }
}
