import SwiftUI
import FoundationModels
import Combine

struct Message: Identifiable {
    var id = UUID()
    var text: String
    let isUser: Bool
}

enum ChatStage {
    case askLocalName
    case askLocalType
    case generateDate
}

@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var currentString: String = ""
    
    private var session: LanguageModelSession?
    
    private var localName: String = ""
    private var localType: String = ""
    
    private var stage: ChatStage = .askLocalName
    
    init() {
        setupSession()
        startConversation()
    }
    
    private func setupSession() {
        self.session = LanguageModelSession()
    }
    
    private func startConversation() {
        messages.append(
            Message(text: "Olá! 👋 Para montar um date perfeito, me diga primeiro: qual é o nome do local?", isUser: false)
        )
    }
    
    func sendMessage() async {
        let trimmed = currentString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messages.append(Message(text: trimmed, isUser: true))
        
        let userText = trimmed
        currentString = ""
        
        switch stage {
        case .askLocalName:
            localName = userText
            stage = .askLocalType
            messages.append(
                Message(text: "Perfeito! E esse lugar é o quê? (Ex: cinema, parque, bar, shopping...)", isUser: false)
            )
            
        case .askLocalType:
            localType = userText
            stage = .generateDate
            await generateDatePlan()
            
        case .generateDate:
            messages.append(
                Message(text: "Se quiser montar outro date, basta dizer um novo local! 😊", isUser: false)
            )
        }
    }
    
    
    private func generateDatePlan() async {
        guard let session else { return }
        
        let prompt = """
        Crie um roteiro romântico, leve e divertido para um encontro, baseado nas informações abaixo:

        Local: \(localName)
        Tipo do local: \(localType)

        Diretrizes importantes:
        - NÃO invente detalhes específicos do local. NÃO descreva elementos únicos, layout, decoração, cardápio, atrações ou serviços que você não tem certeza que existem.
        - Utilize apenas atividades que são UNIVERSALMENTE possíveis para o tipo de local informado.  
          Exemplos:
            • Para cinemas: comprar ingressos, escolher lugares, assistir ao filme, conversar antes/depois.
            • Para parques: caminhar, sentar em bancos, conversar, observar natureza genérica.
            • Para cafés: pedir bebidas, sentar à mesa, conversar.
            • Para shoppings: caminhar, entrar em lojas genéricas, sentar na praça.
            • Para bares: pedir bebidas, conversar na mesa.
            • Para museus: observar exposições genéricas, caminhar, comentar obras.
            (Cada tipo só deve receber atividades compatíveis com seu funcionamento padrão.)
        - Clima desejado: romântico, acolhedor, divertido, casual e adequado para pessoas que estão se conhecendo.
        - Proponha atividades que criem conexão natural, sem intimidade excessiva.
        - Estruture com: início, meio e fim.
        - Sugira entre 3 e 5 atividades viáveis dentro do tipo de local informado.
        - Inclua pequenos detalhes que ajudem o casal a se conectar (gestos gentis, brincadeiras leves, tópicos de conversa).
        - No final, inclua um toque especial simples, memorável e sempre leve.
        - NÃO faça metacomentários.
        - NÃO diga que é IA.
        - Responda SOMENTE com o roteiro final.
        """
        do {
            let response = try await session.respond(to: prompt)
            messages.append(Message(text: response.content, isUser: false))
            
            messages.append(
                Message(text: "Se quiser planejar outro lugar, é só me dizer o nome! 😉", isUser: false)
            )
            
            stage = .askLocalName
            
        } catch {
            messages.append(
                Message(text: "Não consegui gerar o roteiro agora. Pode tentar de novo? 😅", isUser: false)
            )
        }
    }
}
