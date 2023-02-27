//
//  Prova.swift
//  BrainWave-App
//
//  Created by benedetta on 25/02/23.
//

import SwiftUI

struct Prova: View {
    let array = ["Ciao", "Come stai?", "Buongiorno", "Buonasera"]

        @State var text: String = ""
    var body: some View {
        VStack {
                    TextField("Scrivi qui", text: $text)
                    Button(action: {
                        let randomIndex = Int.random(in: 0..<self.array.count)
                        self.text = self.array[randomIndex]
                    }) {
                        Text("Premi")
                    }
                }    }
}

struct Prova_Previews: PreviewProvider {
    static var previews: some View {
        Prova()
    }
}
