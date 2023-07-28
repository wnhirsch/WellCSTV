//
//  SplashScreenView.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var timer: Timer? = nil
    @State private var showMainView: Bool = false
    
    private let logoHeight: CGFloat = 113
    
    // MARK: Body
    var body: some View {
        VStack {
            Image(.logo)
                .square(logoHeight)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cstvBackground)
        .navigationDestination(isPresented: $showMainView) {
            MatchListView()
                .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                showMainView = true
            }
        }
    }
}

// MARK: Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplashScreenView()
        }
    }
}
