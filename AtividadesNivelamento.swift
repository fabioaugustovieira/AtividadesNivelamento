struct Contato {
    let id: Int
    var nome: String
    var idade: Int
    var telefone: String
    var email: String
}	


struct GerenciadorContatos {
    
    private var contatos: [Contato] = []
    private var proximoId = 1
    
    // MARK: - Cadastro
    mutating func cadastrar() {
        print("Nome:")
        guard let nome = readLine(), !nome.isEmpty else {
            print("❌ Nome inválido")
            return
        }
        
        if contatos.contains(where: { $0.nome.lowercased() == nome.lowercased() }) {
            print("❌ Nome já cadastrado")
            return
        }
        
        print("Idade:")
        guard let idadeStr = readLine(),
              let idade = Int(idadeStr) else {
            print("❌ Idade inválida")
            return
        }
        
        print("Telefone:")
        guard let telefone = readLine(), !telefone.isEmpty else {
            print("❌ Telefone inválido")
            return
        }
        
        print("Email:")
        guard let email = readLine(), !email.isEmpty else {
            print("❌ Email inválido")
            return
        }
        
        let contato = Contato(id: proximoId, nome: nome, idade: idade, telefone: telefone, email: email)
        contatos.append(contato)
        proximoId += 1
        
        print("✅ Contato cadastrado com sucesso!\n")
    }
    
    // MARK: - Listagem
    func listar() {
        if contatos.isEmpty {
            print("📭 Nenhum contato cadastrado")
            return
        }
        
        for contato in contatos {
            print("""
            ID: \(contato.id)
            Nome: \(contato.nome)
            Idade: \(contato.idade)
            Telefone: \(contato.telefone)
            Email: \(contato.email)
            ---------------------
            """)
        }
    }
    
    // MARK: - Alteração
    mutating func alterar() {
        listarNomes()
        print("Informe o ID do contato para alterar:")
        
        guard let idStr = readLine(),
              let id = Int(idStr),
              let index = contatos.firstIndex(where: { $0.id == id }) else {
            print("❌ ID inválido")
            return
        }
        
        print("Novo nome:")
        guard let nome = readLine(), !nome.isEmpty else {
            print("❌ Nome inválido")
            return
        }
        
        if contatos.contains(where: { $0.nome.lowercased() == nome.lowercased() && $0.id != id }) {
            print("❌ Nome já existente")
            return
        }
        
        print("Nova idade:")
        guard let idadeStr = readLine(),
              let idade = Int(idadeStr) else {
            print("❌ Idade inválida")
            return
        }
        
        print("Novo telefone:")
        guard let telefone = readLine(), !telefone.isEmpty else {
            print("❌ Telefone inválido")
            return
        }
        
        print("Novo email:")
        guard let email = readLine(), !email.isEmpty else {
            print("❌ Email inválido")
            return
        }
        
        contatos[index].nome = nome
        contatos[index].idade = idade
        contatos[index].telefone = telefone
        contatos[index].email = email
        
        print("✅ Contato alterado com sucesso!\n")
    }
    
    // MARK: - Remoção
    mutating func remover() {
        listarNomes()
        print("Informe o ID do contato para remover:")
        
        guard let idStr = readLine(),
              let id = Int(idStr),
              let index = contatos.firstIndex(where: { $0.id == id }) else {
            print("❌ ID inválido")
            return
        }
        
        contatos.remove(at: index)
        print("✅ Contato removido com sucesso!\n")
    }
    
    // MARK: - Auxiliar
    private func listarNomes() {
        for contato in contatos {
            print("ID: \(contato.id) - Nome: \(contato.nome)")
        }
    }
}

var gerenciador = GerenciadorContatos()
var opcao = 0

repeat {
    print("""
    ===== MENU =====
    1 - Cadastrar contato
    2 - Listar contatos
    3 - Alterar contato
    4 - Remover contato
    5 - Finalizar
    Escolha uma opção:
    """)
    
    if let entrada = readLine(),
       let escolha = Int(entrada) {
        opcao = escolha
    }
    
    switch opcao {
    case 1:
        gerenciador.cadastrar()
    case 2:
        gerenciador.listar()
    case 3:
        gerenciador.alterar()
    case 4:
        gerenciador.remover()
    case 5:
        print("👋 Sistema finalizado")
    default:
        print("❌ Opção inválida")
    }
    
} while opcao != 5