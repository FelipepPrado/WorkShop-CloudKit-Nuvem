import SwiftUI
import Nuvem

struct AddTrainerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var trainers: [Trainer.Observable]
    
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
                        saveTrainer()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add Trainer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func saveTrainer() {
        Task{
            var newTrainer = Trainer(name: name, age: Int(age) ?? 0)
            do{
                try await newTrainer.save(on: .private)
                
                //Ele só adicionar um elemento novo, se conseguir salvar o elemento no CloudKit
                trainers.append(newTrainer.observable)
                trainers =  trainers.sorted(by: { $0.name < $1.name })
            } catch{
                print(error)
            }
            dismiss()
        }
    }
}
