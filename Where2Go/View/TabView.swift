//
//  TabView.swift
//  Where2Go
//
//  Created by Jota Pe on 21/11/25.
//

import SwiftUI

struct AppTabView: View {
    
    let primaryColor = Color.vermelho
    
    var body: some View {
        TabView {
            // MARK: - Tab 1: Mapa
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
            // MARK: - Tab 2: Chat de IA
            EncontroView()
                .tabItem {
                    Label("IA", systemImage: "brain.head.profile")
                }
        }
        .tint(primaryColor)
    }
}
// MARK: - Preview
struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
