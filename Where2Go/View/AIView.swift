import SwiftUI

struct EncontroView: View {
    
    @StateObject private var viewModel = ChatViewModel()
    
    let mainColor = Color(.white)
    
    var body: some View {
        ZStack {
            mainColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("E-ncontro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                    Spacer()
                }
                .background(Color(red: 0.5, green: 0.05, blue: 0.2))
                
                ScrollViewReader { reader in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            ForEach(viewModel.messages) { msg in
                                ChatBubble(message: msg)
                                    .id(msg.id)
                            }
                            
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: viewModel.messages.count) { _,_ in
                        if let last = viewModel.messages.last?.id {
                            withAnimation {
                                reader.scrollTo(last, anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack {
                    HStack {
                        TextField("Digite aqui...", text: $viewModel.currentString)
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 1)
                        
                        Button {
                            Task {
                                await viewModel.sendMessage()
                            }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.7, green: 0.3, blue: 0.45))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.bottom, 5)
            }
        }
    }
}

#Preview {
    EncontroView()
}
