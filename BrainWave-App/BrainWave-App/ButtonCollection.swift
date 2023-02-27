//
//  ButtonCollection.swift
//  BrainWave-App
//
//  Created by benedetta on 23/02/23.
//

import SwiftUI

struct ButtonCollection: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var dimHeightCollect: CGFloat {
        if screenWidth > 1200 {
            return 200
        } else {
            return 150
            
        }
    }
    var dimWidthCollect: CGFloat {
        if screenWidth > 1200 {
            return 1150
        } else {
            return 1000
        }
    }
    var paddingCollect: CGFloat {
        if screenWidth > 1200 {
            return 120
        } else {
            return 100
        }
    }
    
    var body: some View {
        
        NavigationLink(destination: MyCollectionView()) {
     
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ImagePaint(image: Image("collectionBack")))
                    .frame(width: screenWidth-32, height: dimHeightCollect)
                    .scaledToFit()
                    .cornerRadius(20)
            Text("My Collection")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.top, paddingCollect)
                .shadow(radius: 5)
        }
            
        }
    }
}

struct ButtonCollection_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCollection()
    }
}
