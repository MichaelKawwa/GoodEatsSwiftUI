//
//  ContentView.swift
//  GoodEatsSwiftUI
//
//  Created by Michael Kawwa on 9/18/20.
//  Copyright © 2020 Michael Kawwa. All rights reserved.
//

import SwiftUI


struct Bussiness: Codable, Hashable {    
    
    let image_url: String?
    let name: String?
    let location: location?
    
    
}

struct location: Codable, Hashable {
    let city: String?
    let country: String?
    let state: String?
    let address1: String?
    let zip_code: String?
}


struct Bussinesses: Codable {
    var businesses: [Bussiness]
}

struct ContentView: View {
    
    @State private var bussinesses = [Bussiness]()
    
    @ObservedObject var locationviewModel = locationViewModel()

        /*
        [
        Bussiness(id: 0, imageName: "bagelboy", name: "Bagel Boy", adress: "8002 3rd Ave, Brooklyn, NY 11209", info: "Deli & bakery offering bagels, wraps, panini & sub sandwiches, plus soups & salads."),
        Bussiness(id: 1, imageName: "foundryBurger", name: "South Brooklyn Foundry", adress: "6909 3rd Ave, Brooklyn, NY 1120", info: "American, Breakfast and Brunch, Burgers."),
        Bussiness(id: 2, imageName: "omonia", name: "Omonia Cafe", adress: "7612-14 3rd Ave, Brooklyn, NY 11209", info: "Local Greek chain with a late-night scene doling out traditional sweets & savory dishes since 1977.")
    ] */
    
    private func getCardWidth(geometry: GeometryProxy, id: Int) -> CGFloat {
    // offset the width by 10 each time
        let offset: CGFloat = CGFloat(bussinesses.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    
    
    private func getCardOffset(geometry: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(bussinesses.count - 1 - id) * 10
    }
  
    
     func loadData() {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=\(locationviewModel.userLatitude)&longitude=\(locationviewModel.userLongitude)") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
        urlRequest.setValue("Bearer RnCGTK_qmb2zlWiCUy0rvj-y2SIkyfrL63UZNKR4JxaK1qMFWdLR4PDneGlbGMEDoimZhb1WxScLmgoIWfctVNJxAMJWG-bCW1bZinUaXHftNhH_6Y3RdAEMtyXNYHYx", forHTTPHeaderField:"Authorization")
                
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                let parsedJson = try jsonDecoder.decode(Bussinesses.self, from: data)
                    for bussiness in parsedJson.businesses {
                        self.bussinesses.append(bussiness)
                    }
                } catch {
                    print(error)
                }
            } else {
                print("error 2")
            }
        }.resume()
        
    }
        
    
    var body: some View {
            GeometryReader {geometry in
                VStack {
    
                    Spacer()
                    ZStack {
                      /*  ForEach(self.bussinesses, id: \.self) { bussiness in
                                Card(bussiness: bussiness, onRemove: {bussiness in
                                    self.bussinesses.removeAll{ $0.id == bussiness.id }
                                })
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry: geometry, id: bussiness.id), height: 400)
                                .offset(x: 0, y: self.getCardOffset(geometry: geometry, id: bussiness.id))
                        } */
                        ForEach(0..<bussinesses.count, id: \.self) { i in
                            Group {
                                if (bussinesses.count-4)...bussinesses.count  ~= i {
                            Card(bussiness: bussinesses[i], onRemove: {bussiness in
                                print(bussinesses[i])
                                self.bussinesses.remove(at: i)
                            })
                            .animation(.spring())
                            .frame(width: self.getCardWidth(geometry: geometry, id: i), height: 400)
                            .offset(x: 0, y: self.getCardOffset(geometry: geometry, id: i))
                        }
                       }
                      }
                    }.onAppear(perform: loadData)
                    Spacer()
                }.onAppear(perform: loadData)
            }.padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
