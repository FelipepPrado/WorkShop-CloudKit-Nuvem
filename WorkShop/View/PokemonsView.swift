import SwiftUI
import Nuvem

struct PokemonsView: View {
    @Bindable var trainer: Trainer.Observable
    
    @State private var addPokemon: Bool = false
    @State private var pokemonEdit: Pokemon.Observable?
    
    var body: some View {
        List{
            ForEach(trainer.pokemons) { pokemon in
                HStack{
                    VStack(alignment: .leading){
                        Text("\(pokemon.name)")
                        Image(pokemon.type)
                    }
                    
                    Spacer()
                    
                    if pokemon.isShiny {
                        Image(systemName: "sparkles")
                            .foregroundColor(.yellow)
                    }
                }
                .swipeActions(edge: .trailing){
                    Button("Delete", systemImage: "trash.fill"){
                        deletePokemon(pokemon: pokemon.observable)
                    }
                    .tint(.red)
                    
                    Button("Edit", systemImage: "square.and.pencil"){
                        pokemonEdit = pokemon.observable
                    }
                    .tint(.blue)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listRowSpacing(10)
        .sheet(isPresented: $addPokemon){
            AddPokemonView(trainer: trainer)
        }
        .sheet(item: $pokemonEdit) { pokemon in
            EditPokemonView(trainer: trainer, pokemon: pokemon)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button("Add Pokémon", systemImage: "plus"){
                    addPokemon.toggle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .navigationTitle("\(trainer.name)'s Pokémon")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func deletePokemon(pokemon: Pokemon.Observable) {
        Task{
            do {
                try await pokemon.delete(on: .private)
                trainer.pokemons.removeAll(where: { $0.id == pokemon.id })
            } catch{
                print(error)
            }
        }
    }
}
