//
//  MapView.swift
//  Where2Go
//
//  Created by Jota Pe on 21/11/25.
//

import SwiftUI
import MapKit

// MARK: - 1. Estrutura de Dados do Local
struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// MARK: - 2. Componente do menu de filtro
struct FilterMenu: View {
    let title: String
    @Binding var selectedValue: String
    let options: [String]
    let primaryColor: Color

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button{
                    selectedValue = option
                } label: {
                    HStack{
                        Text(option)
                        if selectedValue == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            Divider()
            
            Button(role: .destructive){
                selectedValue = options.first ?? ""
            } label: {
                Text("Limpar Filtro")
                Image(systemName: "xmark.circle")
            }
            
        } label: {
            HStack{
                Text(title)
                    .font(.caption)
                Text(selectedValue)
                    .font(.footnote)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.8))
            .foregroundStyle(primaryColor)
            .cornerRadius(10)
            .shadow(radius: 1)
        }
    }
}

// MARK: - 3. Tela Principal do Mapa
struct MapView: View {

    
    // Lista de locais de exemplo (mock data)
    @State private var places = [
        Place(name: "Fran's Café", coordinate: CLLocationCoordinate2D(latitude: -15.841733385979662, longitude: -48.02418096174187)),
        Place(name: "À La Vonté Pizzaria", coordinate: CLLocationCoordinate2D(latitude: -15.847081510870849, longitude: -47.97954326174186)),
        Place(name: "Park Shopping", coordinate: CLLocationCoordinate2D(latitude: -15.833240673323662, longitude: -47.95493337301267))
    ]
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -18.15, longitude: -47.6),
            span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5)
        )
        
        // MARK: - Estados para os Filtros (Valores Atuais)
        @State private var selectedType: String = "Date"
        @State private var selectedStyle: String = "Romântico"
        @State private var selectedDistance: String = "2km"
        
        // MARK: - Opções de Filtro (Para você preencher!)
        let typeOptions = ["Date", "Amigos", "Família", "Negócios"]
        let styleOptions = ["Romântico", "Casual"]
        let distanceOptions = ["2km", "5km", "10km", "Toda a Região"]
        
    let primaryColor = Color(.vermelho)

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(primaryColor)
                        Rectangle()
                            .fill(primaryColor)
                            .frame(width: 5, height: 5)
                            .rotationEffect(.degrees(45))
                            .offset(y: -4)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            // 3.2. Container do Cabeçalho e Filtros
            VStack{
                Rectangle()
                    .fill(primaryColor)
                    .frame(height: 150)
                    .edgesIgnoringSafeArea(.all)
                //filtro
                HStack(spacing: 2) {
                    Spacer()
                    FilterMenu(
                        title: "Tipo",
                        selectedValue: $selectedType,
                        options: typeOptions,
                        primaryColor: primaryColor
                    )
                    FilterMenu(
                        title: "Estilo",
                        selectedValue: $selectedStyle,
                        options: styleOptions,
                        primaryColor: primaryColor
                    )
                    FilterMenu(
                        title: "Distância",
                        selectedValue: $selectedDistance,
                        options: distanceOptions,
                        primaryColor: primaryColor
                    )
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.95))
                .cornerRadius(15)
                .padding(.horizontal, 10)
                .offset(y: -68)
                .shadow(radius: 3)
                
                Spacer()
            }
            // 3.3. Títulos e Navegação (sobrepondo o retângulo de fundo)
            VStack {
                // Título e botão "Voltar"
                ZStack {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding(.bottom, 60)
                            .padding(.leading)
                        Spacer()
                        Text("Ideias de E-ncontro")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.trailing, 60)
                            .padding(.bottom, 60)
                    }
                }
                .foregroundColor(.white)
                .padding(.top, 50)
                Spacer()
            }
        }
    }
}
// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
