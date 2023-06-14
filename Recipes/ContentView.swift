//
//  ContentView.swift
//  Recipes
//
//  Created by Haytham Odeh on 6/12/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            MealListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


