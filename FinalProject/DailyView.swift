//
//  DailyView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/8.
//

import SwiftUI

struct Restaurant: Identifiable{
    var id = UUID()
    var name:String
    var image:String
}

var restaurants = [
Restaurant(name: "Cafe Deadend", image: "cafedeadend"),
Restaurant(name: "Homei", image: "homei"),
Restaurant(name: "Teakha", image: "teakha"),
Restaurant(name: "Cafe Loisl", image: "cafeloisl"),
Restaurant(name: "Petite Oyster", image: "petiteoyster"),
Restaurant(name: "For Kee Restaurant", image: "forkeerestaurant"),
Restaurant(name: "Po's Atelier", image: "posatelier"),
Restaurant(name: "Bourke Street Bakery", image: "bourkestreetbakery"),
Restaurant(name: "Haigh's Chocolate", image: "haighschocolate"),
Restaurant(name: "Palomino Espresso", image: "palominoespresso"),
Restaurant(name: "Upstate", image: "upstate"),
Restaurant(name: "Traif", image: "traif"),
Restaurant(name: "Graham Avenue Meats And Deli", image: "grahamavenuemeats"),
Restaurant(name: "Waffle & Wolf", image: "wafflewolf"),
Restaurant(name: "Five Leaves", image: "fiveleaves"),
Restaurant(name: "Cafe Lore", image: "cafelore"),
Restaurant(name: "Confessional", image: "confessional"),
Restaurant(name: "Barrafina", image: "barrafina"),
Restaurant(name: "Donostia", image: "donostia"),
Restaurant(name: "Royal Oak", image: "royaloak"),
Restaurant(name: "CASK Pub and Kitchen", image: "caskpubkitchen")
]


var restaurantNames = ["Cafe Deadend", "Homei", "Teakha",
"Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po'sAtelier", "Bourke Street Bakery", "Haigh's Chocolate",
"Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats And Deli", "Waffle & Wolf", "Five Leaves", "Cafe Lore",
"Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]

var restaurantImages = ["cafedeadend", "homei", "teakha",
"cafeloisl", "petiteoyster", "forkeerestaurant",
"posatelier", "bourkestreetbakery", "haighschocolate",
"palominoespresso", "upstate", "traif", "grahamavenuemeats",
"wafflewolf", "fiveleaves", "cafelore", "confessional",
"barrafina", "donostia", "royaloak", "caskpubkitchen"]

struct DailyView: View {
    @ObservedObject var viewModel1 = HomeViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(viewModel1: HomeViewModel())
    }
}
