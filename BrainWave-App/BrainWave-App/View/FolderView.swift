//
//  FolderView.swift
//  BrainWave-App
//
//  Created by Serena on 01/03/23.
//

import SwiftUI

struct FolderView: View {
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color("myGray"))
                .opacity(0.5)
                .frame(width: 180, height: 150)
                .cornerRadius(15)
            Text(name)
        }
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(name: "Name")
    }
}
