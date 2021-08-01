//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Zaheer Moola on 2021/07/14.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: OrderCart

    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showingConfirmation = false

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                        .accessibility(hidden: true)

                    Text("Your total is $\(order.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func placeOrder() {
        guard let encodedOrder = try? JSONEncoder().encode(order) else {
            debugPrint("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedOrder

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                handleError()
                return
            }

            if let decodedOrder = try? JSONDecoder().decode(OrderCart.self, from: data) {
                self.alertMessage = "Your order for \(decodedOrder.order.quantity)x \(Order.types[decodedOrder.order.type].lowercased()) cupcakes is on its way!"
                self.alertTitle = "Thank you!"
                self.showingConfirmation = true
            } else {
                handleError()
            }
        }.resume()
    }

    private func handleError() {
        self.alertTitle = "Error!"
        self.alertMessage = "Looks like something went wrong, please try again."
        self.showingConfirmation = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: OrderCart())
    }
}
