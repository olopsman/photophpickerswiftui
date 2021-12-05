//
//  ContentView.swift
//  PhotoPHPickerSwiftUI
//
//  Created by Paulo Orquillo on 5/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var presentImagePicker = false
    @State var images : [UIImage] = []
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<images.count, id:\.self) {index in
                        let image = images[index]
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .overlay(
                                
                                Button(action: {
                                    //delete image
                                    images.remove(at: index)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 30, height: 30)
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                },
                                alignment: .topLeading
                            )

                    }
                }
            }
            
            Button(action: {
                presentImagePicker.toggle()
            }) {
                Text("Pick Images")
            }
        }
        .sheet(isPresented: $presentImagePicker) {
            PhotoPicker(images: $images)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
