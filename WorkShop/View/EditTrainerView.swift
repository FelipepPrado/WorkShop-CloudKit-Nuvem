import SwiftUI
import Nuvem

struct EditTrainerView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var trainer: Trainer.Observable
    
    @State private var name: String = ""
    @State private var age: Date = Date.now
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Name"){
                    TextField("Type the trainer name", text: $name)
                }
                Section("Age"){
                    DatePicker(
                        "Birth date",
                        selection: $age,
                        in: ...Date.now,
                        displayedComponents: .date,
                    )
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
                    .disabled(name.isEmpty || (name == trainer.name && age == trainer.age))
                }
            }
            .navigationTitle("Edit Trainer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            name = trainer.name
            age = trainer.age
        }
    }
    
    func updateTrainer() {
        Task{
            trainer.name = name
            trainer.age = age
            
            do{
                try await trainer.save(on: .private)   
            } catch{
                print(error)
            }
            
            dismiss()
        }
    }
}
