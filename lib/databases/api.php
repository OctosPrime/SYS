<?php
header('Content-Type: application/json');
include 'https://sysmedical.net.br/apis/dbRest.php';

// Função para inserir um usuário
function inserirUsuario($conn, $nome, $email, $celular, $senha) {
    $sql = $conn->prepare("INSERT INTO usuarios (nome, email, celular, senha, adm) VALUES (?, ?, ?, ?, 0)");
    $sql->bind_param("ssss", $nome, $email, $celular, $senha);
    
    if ($sql->execute()) {
        echo json_encode(['success' => true, 'insertId' => $sql->insert_id]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Erro ao inserir usuário: ' . $sql->error]);
    }
}

// Função para criar um chamado
function criarChamado($conn, $tipo, $chamado, $cliente, $equipamento, $data, $endereco, $celular, $link, $observacao, $tecnico, $status) {
    $sql = $conn->prepare("INSERT INTO chamados (tipo, chamado, cliente, equipamento, data, endereco, celular, link, observacao, tecnico, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $sql->bind_param("sssssssssss", $tipo, $chamado, $cliente, $equipamento, $data, $endereco, $celular, $link, $observacao, $tecnico, $status);
    
    if ($sql->execute()) {
        echo json_encode(['success' => true, 'insertId' => $sql->insert_id]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Erro ao criar chamado: ' . $sql->error]);
    }
}

// Função para verificar credenciais
function verificarCredenciais($conn, $email, $senha) {
    $sql = $conn->prepare("SELECT * FROM usuarios WHERE email = ? AND senha = ?");
    $sql->bind_param("ss", $email, $senha);
    $sql->execute();
    $result = $sql->get_result();
    
    if ($result->num_rows > 0) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Email ou senha incorretos.']);
    }
}

// Roteamento simples
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    if (isset($input['action'])) {
        switch ($input['action']) {
            case 'inserirUsuario':
                inserirUsuario($conn, $input['nome'], $input['email'], $input['celular'], $input['senha']);
                break;
            case 'criarChamado':
                criarChamado($conn, $input['tipo'], $input['chamado'], $input['cliente'], $input['equipamento'], $input['data'], $input['endereco'], $input['celular'], $input['link'], $input['observacao'], $input['tecnico'], $input['status']);
                break;
            case 'verificarCredenciais':
                verificarCredenciais($conn, $input['email'], $input['senha']);
                break;
            default:
                echo json_encode(['success' => false, 'message' => 'Ação inválida.']);
                break;
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Nenhuma ação fornecida.']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Método HTTP inválido.']);
}

$conn->close();
?>