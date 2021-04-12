//
//  AddToDoView.swift
//  ToDoListSwiftUI
//
//  Created by Admin on 15/02/21.
//
//kita punya id yg membutuhkan sebuah urutan misal 1,2,3 .... maka membutuhkan identifiable
//kita punya id yg ga butuh sebuah urutan maka dia menggunakan \.self
//

import SwiftUI

struct AddToDoView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var Priority: String = "Normal"
    
    @State private var showingError: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    let priorities = ["High", "Normal", "Low"]
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading, spacing: 20){
                    TextField("ToDo", text: $name) //untuk mengupdate data kita
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold,design: .default))
                    
                    Picker("Priority", selection: $Priority){
                        ForEach(priorities, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if self.name != ""{
                            let todo = ToDo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.Priority
                            
                            do{
                                try self.managedObjectContext.save()
                                print("new todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                            }catch{
                                print(error)
                            }
                        }else{
                            self.showingError = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Isi bagian yang kosong"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .navigationBarTitle("New ToDo",displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "xmark")
                }
            ).alert(isPresented: $showingError){
                Alert(title: Text(errorTitle),message: Text(errorMessage),dismissButton: .default(Text("Ok")))
            }
            
        }
            
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView()
    }
}
