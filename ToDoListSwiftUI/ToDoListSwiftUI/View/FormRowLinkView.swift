//
//  FormRowLinkView.swift
//  ToDoListSwiftUI
//
//  Created by Admin on 22/02/21.
//

import SwiftUI

struct FormRowLinkView: View {
    
    var icon: String
    var firstText: String
    var secondText: String
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.gray)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(firstText).foregroundColor(.gray)
            Spacer()
            Text(secondText)
        }
        
    }
}

struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(icon: "gear", firstText: "Application", secondText: "ToDo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
