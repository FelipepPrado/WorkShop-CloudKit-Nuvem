import SwiftUI
import Nuvem

struct ContentView: View {
    @State private var trainers: [Trainer.Observable] = []
    @State private var addTrainer: Bool = false
    @State private var trainerEdit: Trainer.Observable?
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(trainers){ trainer in
                    NavigationLink(destination: PokemonsView(trainer: trainer)){
                        VStack{
                            Text("\(trainer.name)")
                        }
                    }
                    .swipeActions(edge: .trailing){
                        Button("Delete", systemImage: "trash.fill"){
                            deleteTrainer(trainer: trainer)
                        }
                        .tint(.red)
                        
                        Button("Edit", systemImage: "square.and.pencil"){
                            trainerEdit = trainer
                        }
                        .tint(.blue)
                    }
                }
            }
            .sheet(isPresented: $addTrainer){
                AddTrainerView(trainers: $trainers)
            }
            .sheet(item: $trainerEdit) { trainer in
                EditTrainerView(trainer: trainer)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add Trainer", systemImage: "plus"){
                        addTrainer.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .navigationTitle("Pokémon Trainers")
            .navigationBarTitleDisplayMode(.large)
        }
        .task{
            fetchTrainers()
        }
    }
    
    func fetchTrainers() {
        Task{
            do {
                trainers = try await Trainer.query(on: .private)
                    .with(\.$pokemons)
                    .all()
                    .map(\.observable)
            } catch{
                print(error)
            }
        }
    }
    
    func deleteTrainer(trainer: Trainer.Observable) {
        Task{
            do {
                try await trainer.delete(on: .private)
                fetchTrainers()
            } catch{
                print(error)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
