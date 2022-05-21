//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct ConstraintsContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>

    var body: some View {
        VStack {
            List(wizards) { wizard in
                Text(wizard.name ?? "Unknown")
            }

            Button("Add") {
                let wizard = Wizard(context: managedObjectContext)
                wizard.name = "Harry Potter"
            }

            Button("Save") {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct FilteringContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == 'Star Wars'")) var ships: FetchedResults<Ship>

    var body: some View {
        VStack {
            List(ships) { ship in
                Text(ship.name ?? "Unknown name")
            }

            Button("Add Examples") {
                let ship1 = Ship(context: managedObjectContext)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: managedObjectContext)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: managedObjectContext)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: managedObjectContext)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? managedObjectContext.save()
            }

            Button("Show Only Star Wars") {
                ships.nsPredicate = NSPredicate(format: "universe == %@", "Star Wars")
            }

            Button("Show Only Star Trek") {
                ships.nsPredicate = NSPredicate(format: "universe == %@", "Star Trek")
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>

    var body: some View {
        VStack {
            List {
                ForEach(countries) { country in
                    Section(country.countryFullName) {
                        ForEach(country.countryCandy) { candy in
                            Text(candy.candyName)
                        }
                    }
                }
            }

            Button("Add") {
                let candy1 = Candy(context: managedObjectContext)
                candy1.name = "Mars"
                candy1.origin = Country(context: managedObjectContext)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: managedObjectContext)
                candy2.name = "KitKat"
                candy2.origin = Country(context: managedObjectContext)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: managedObjectContext)
                candy3.name = "Twix"
                candy3.origin = Country(context: managedObjectContext)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: managedObjectContext)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: managedObjectContext)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                try? managedObjectContext.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
