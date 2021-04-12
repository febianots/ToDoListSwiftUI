//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by Admin on 15/02/21.
//
//NSManagedObject = dia dapat mengikat objek model kita ke bagian antarmuka / interface / UI
//ManagedObjectContext = menyimpan konteks objek yang terkelola
//

//fetch request = tugasnya menampikan hasil proses data dari managedObjectContext untuk di tampilkan ke halaman interface aplikasi
//ascending = urutan dari yang terkecil ke terbesar
//descending = urutan dari yang terbesar ke terkecil



import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: ToDo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDo.name, ascending: true)]) var todos: FetchedResults<ToDo>
    @State private var showingAddToDo: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    ForEach(self.todos,id: \.self){todo in
                        HStack{
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorsize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                        }
                    }
                    .onDelete(perform: deleteToDo)
                }.navigationBarTitle("ToDo",displayMode: .inline)
                    .navigationBarItems(leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                                        trailing:
                        Button(action: {
                            self.showingSettingsView.toggle()
                        }){
                            Image(systemName: "slider.horizontal.3")
                        }
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView){
                            SettingsView().environmentObject(self.iconSettings)
                        }
                )
                if todos.count == 0{
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddToDo){
                AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack{
                    Button(action:{
                        self.showingAddToDo.toggle()
                    }){
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                }
                .padding(.bottom,15)
                .padding(.trailing,15)
                ,alignment: .bottomTrailing
            )
            
        }
    }
    
    private func deleteToDo(at offsets: IndexSet){ //komponen array = object urutan nama lain adalah index
        for index in offsets{
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do{
                try managedObjectContext.save()
            }catch{
                print(error)
            }
        }
    }
    
    private func colorsize(priority: String) -> Color {
        switch priority{
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
