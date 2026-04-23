import SwiftUI

//  Modelos

struct Pergunta: Identifiable {
    let id = UUID()
    let texto: String
    let opcoes: [String]
    let correta: Int
}

enum Tema: String, CaseIterable, Identifiable {
    case matematica = "Matemática"
    case historia = "História"
    
    var id: String { rawValue }
}

enum Dificuldade: String, CaseIterable, Identifiable {
    case facil = "Fácil"
    case media = "Média"
    case dificil = "Difícil"
    
    var id: String { rawValue }
    
    var quantidadeOpcoes: Int {
        switch self {
        case .facil: return 4
        case .media: return 3
        case .dificil: return 2
        }
    }
    
    var pulosPermitidos: Int {
        switch self {
        case .facil: return 2
        case .media: return 1
        case .dificil: return 0
        }
    }
}

//  Banco de Perguntas

let bancoPerguntas: [Tema: [Pergunta]] = [
    .matematica: [
        Pergunta(texto: "Quanto é 2 + 2?", opcoes: ["3", "4", "5", "6"], correta: 1),
        Pergunta(texto: "5 × 3 é igual a?", opcoes: ["10", "12", "15", "20"], correta: 2),
        Pergunta(texto: "10 ÷ 2 é?", opcoes: ["2", "3", "5", "8"], correta: 2),
        Pergunta(texto: "7 + 6?", opcoes: ["12", "13", "14", "15"], correta: 1),
        Pergunta(texto: "9 × 2?", opcoes: ["16", "18", "20", "22"], correta: 1),
        Pergunta(texto: "8 + 5?", opcoes: ["11", "12", "13", "14"], correta: 2),
        Pergunta(texto: "6 × 6?", opcoes: ["30", "32", "36", "40"], correta: 2)
    ],
    
    .historia: [
        Pergunta(texto: "Quem descobriu o Brasil?", opcoes: ["Dom Pedro", "Pedro Álvares Cabral", "Getúlio Vargas", "Tiradentes"], correta: 1),
        Pergunta(texto: "Ano da Independência do Brasil?", opcoes: ["1808", "1822", "1889", "1945"], correta: 1),
        Pergunta(texto: "Quem foi o primeiro presidente do Brasil?", opcoes: ["Getúlio Vargas", "Deodoro da Fonseca", "Juscelino", "Lula"], correta: 1),
        Pergunta(texto: "Capital do Império Brasileiro?", opcoes: ["São Paulo", "Brasília", "Salvador", "Rio de Janeiro"], correta: 3),
        Pergunta(texto: "Abolição da escravidão ocorreu em?", opcoes: ["1870", "1888", "1890", "1900"], correta: 1),
        Pergunta(texto: "Quem proclamou a República?", opcoes: ["Dom Pedro I", "Dom Pedro II", "Deodoro", "Cabral"], correta: 2)
    ]
]

//  View Principal

struct ContentView: View {
    
    @State private var nomeJogador = ""
    @State private var temaSelecionado: Tema?
    @State private var dificuldade: Dificuldade = .facil
    
    @State private var perguntas: [Pergunta] = []
    @State private var indiceAtual = 0
    @State private var acertos = 0
    @State private var erros = 0
    @State private var pulosRestantes = 0
    
    @State private var mostrarResultado = false
    @State private var feedback = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Tela inicial
            if temaSelecionado == nil {
                Text("Jogo de Perguntas")
                    .font(.title)
                    .bold()
                
                TextField("Nome do jogador", text: $nomeJogador)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Picker("Dificuldade", selection: $dificuldade) {
                    ForEach(Dificuldade.allCases) { nivel in
                        Text(nivel.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Escolha um tema")
                    .font(.headline)
                
                ForEach(Tema.allCases) { tema in
                    Button(tema.rawValue) {
                        iniciarJogo(tema)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            // Perguntas
            else if !mostrarResultado {
                let pergunta = perguntas[indiceAtual]
                
                Text("Pergunta \(indiceAtual + 1)/5")
                    .font(.headline)
                
                Text(pergunta.texto)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                ForEach(pergunta.opcoes.indices, id: \.self) { index in
                    Button(pergunta.opcoes[index]) {
                        responder(index)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                }
                
                if pulosRestantes > 0 {
                    Button("Pular pergunta (\(pulosRestantes))") {
                        pularPergunta()
                    }
                    .foregroundColor(.orange)
                }
                
                Text(feedback)
                    .font(.headline)
            }
        }
        .padding()
        .alert("Fim do Jogo", isPresented: $mostrarResultado) {
            Button("OK") {
                reiniciar()
            }
        } message: {
            Text("""
            Jogador: \(nomeJogador)
             Acertos: \(acertos)
             Erros: \(erros)
            """)
        }
    }
    
    //  Lógica
    
    func iniciarJogo(_ tema: Tema) {
        temaSelecionado = tema
        pulosRestantes = dificuldade.pulosPermitidos
        
        perguntas = bancoPerguntas[tema]!
            .shuffled()
            .prefix(5)
            .map { pergunta in
                let opcoes = Array(pergunta.opcoes
                    .shuffled()
                    .prefix(dificuldade.quantidadeOpcoes))
                
                let corretaTexto = pergunta.opcoes[pergunta.correta]
                let novaCorreta = opcoes.firstIndex(of: corretaTexto) ?? 0
                
                return Pergunta(
                    texto: pergunta.texto,
                    opcoes: opcoes,
                    correta: novaCorreta
                )
            }
        
        indiceAtual = 0
        acertos = 0
        erros = 0
    }
    
    func responder(_ resposta: Int) {
        if resposta == perguntas[indiceAtual].correta {
            acertos += 1
            feedback = " Resposta correta!"
        } else {
            erros += 1
            let correta = perguntas[indiceAtual].opcoes[perguntas[indiceAtual].correta]
            feedback = " Incorreta. Correta: \(correta)"
        }
        
        avancarPergunta()
    }
    
    func pularPergunta() {
        pulosRestantes -= 1
        feedback = " Pergunta pulada"
        avancarPergunta()
    }
    
    func avancarPergunta() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            feedback = ""
            if indiceAtual < perguntas.count - 1 {
                indiceAtual += 1
            } else {
                mostrarResultado = true
            }
        }
    }
    
    func reiniciar() {
        temaSelecionado = nil
        mostrarResultado = false
        nomeJogador = ""
    }
}