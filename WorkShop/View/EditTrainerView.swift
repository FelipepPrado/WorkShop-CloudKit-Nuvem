import SwiftUI
import Nuvem

struct EditTrainerView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var trainer: Trainer.Observable
    
    @State private var name: String = ""
    @State private var age: String = ""
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Name"){
                    TextField("Type the trainer name", text: $name)
                }
                Section("Age"){
                    TextField("Type the trainer age", text: $age)
                        .keyboardType(.numberPad)
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
                        updateTrainer()
                    }
                    .disabled(name.isEmpty || (name == trainer.name && Int(age) ?? 0 == trainer.age))
                }
            }
            .navigationTitle("Edit Trainer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            name = trainer.name
            age = String(trainer.age)
        }
    }
    
    func updateTrainer() {
        Task{
            trainer.name = name
            trainer.age = Int(age) ?? 0
            
            do{
                try await trainer.save(on: .private)   
            } catch{
                print(error)
            }
            
            dismiss()
        }
    }
}
