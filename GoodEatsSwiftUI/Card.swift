//
//  Card.swift
//  GoodEatsSwiftUI
//
//  Created by Michael Kawwa on 6/15/21.
//  Copyright © 2021 Michael Kawwa. All rights reserved.
//

import SwiftUI

extension Color {
    
    static let offwhite = Color(red: 0.96, green: 0.96, blue: 1)
    
}

struct Card: View {
    
    @State private var translation: CGSize = .zero
    
    private var bussiness: Bussiness
    private var onRemove: (_ bussiness: Bussiness) -> Void
    
    private var thresholdPercentage: CGFloat = 0.5
    
    init(bussiness: Bussiness, onRemove: @escaping(_ bussiness: Bussiness) -> Void) {
        self.bussiness = bussiness
        self.onRemove = onRemove
    }
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
           gesture.translation.width / geometry.size.width
       }
    
    var body: some View {
        // 1
        GeometryReader { geometry in
            
            VStack {
                
                Image(systemName: "person.fill").data(url: URL(string: self.bussiness.image_url ?? "https://2rdnmg1qbg403gumla1v9i2h-wpengine.netdna-ssl.com/wp-content/uploads/sites/3/2013/03/drinkSoda-LMC-071320-770x533-1-650x428.jpg")!)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(self.bussiness.name ?? "name not found")
                            .font(.title)
                            .bold()
                            .preferredColorScheme(.light)

                        Text(self.bussiness.location?.address1 ?? "")
                            .font(.headline)
                            .preferredColorScheme(.light)
                        Text(self.bussiness.location?.city ?? "")
                            .foregroundColor(.gray)
                            .bold()
                            .font(.subheadline)
                    })
                }
                
            }
            .padding(.bottom)
            .background(Color.offwhite)
            .cornerRadius(10.0)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width)*25), anchor: .bottom)
            .gesture(
            DragGesture()
                .onChanged({ value in
                    self.translation = value.translation
                }).onEnded({ value in
                    if abs(getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                        self.onRemove(self.bussiness)
                    } else {
                        self.translation = .zero
                    }
                })
            )
        }
    }
}

// 4
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Card(bussiness: Bussiness(image_url: "kdjfkjs", name: "Bagel Boy", location: location(city: "s", country: "sa", state: "s", address1: "s", zip_code: "s")), onRemove: { _ in
            
        }).frame(height: 400).padding()
    }
}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
