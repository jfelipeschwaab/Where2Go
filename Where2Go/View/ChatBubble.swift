//
//  ChatBubble.swift
//  Where2Go
//
//  Created by João Felipe Schwaab on 21/11/25.
//
import Foundation
import SwiftUI

struct ChatBubble: View {

    let message : Message
    
    var body: some View {
        HStack(alignment: .top) {
            if message.isUser {
                Spacer()
            }
            if !message.isUser {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.45))
                    .font(.title2)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 5) {
                Text(message.text)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(message.isUser ? Color("PessoaCor") : Color("IACor"))
                    .cornerRadius(15)
                    .shadow(radius: 2)
            }
            
            if message.isUser {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.45))
                    .font(.title2)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(message.isUser ? .leading : .trailing, 50) // Espaço
        .padding(message.isUser ? .trailing : .leading, 10) // Padding horizontal geral
    }
}
