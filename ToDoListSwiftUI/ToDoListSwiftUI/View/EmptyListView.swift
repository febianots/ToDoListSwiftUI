//
//  EmptyListView.swift
//  ToDoListSwiftUI
//
//  Created by Admin on 18/02/21.
//

import SwiftUI

struct EmptyListView: View {
    @State private var isAnimated : Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    let images : [String] = [
    
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips : [String] = [
        
        "Komitmen",
        "Istiqomah",
        "Change your mine, you change the world",
        "If You Never Try, You Never Know"
    
    
    ]
    
    var body: some View {
        ZStack{
           VStack(alignment: .center, spacing: 20){
                Image("\(images.randomElement() ?? self.images[0])")
                    .renderingMode(.template) // .template = menyesuaikan variabel warnanya
                    .resizable()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                Text("\(tips.randomElement() ?? self.tips[0])").font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0) // bentuk if else yg lebih singkat
            .offset(y: isAnimated ? 0 : -50)
            .animation(.easeOut(duration: 1.5)) // animasi yg di awal cepat di akhirnya lambat
            // .easeIn
            .onAppear(perform: {
                self.isAnimated.toggle()
            })
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView().environment(\.colorScheme, .dark)
    }
}
