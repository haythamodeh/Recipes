import SwiftUI

struct MealDetailView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight

    @State var meal: Meal

    var body: some View {
        ScrollView {
            ZStack {
                AsyncImage(url: URL(string: meal.mealThumb)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: .infinity, height: 150)
                .cornerRadius(20)

                VStack {
                    Spacer()
                    Text(meal.meal)
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(.white.opacity(0.7))
                        .foregroundColor(.black)
                }
            }

            Text(meal.instructions ?? "")

            Divider()

            Section(header: Text("Ingredient - Measurement").font(.headline)) {
                ForEach(meal.ingredientsWithMeasures ?? [], id: \.ingredient) { ingredient, measure in
                    Text("\(ingredient): \(measure)")
                }
            }
        }
        .navigationTitle(meal.meal)
        .padding()
        .onAppear {
            Api().getMealById(id: meal.id) { updatedMeal in
                if let updatedMeal = updatedMeal {
                    self.meal = updatedMeal
                }
            }
        }
    }
}
