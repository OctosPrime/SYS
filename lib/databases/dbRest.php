<?php
$servername = "sysmedicalapp.mysql.dbaas.com.br";
$username = "sysmedicalapp";
$password = "SysMedical123!";
$dbname = "sysmedicalapp";

// Criar conexão
$conn = new mysqli($servername, $username, $password, $dbname);

// Checar conexão
if ($conn->connect_error) {
    die("Conexão falhou: " . $conn->connect_error);
}

function verificarOuCriarTabelas($conn) {
    // Verificar ou criar tabela usuarios
    $sql = "SHOW TABLES LIKE 'usuarios'";
    $result = $conn->query($sql);

    if ($result->num_rows == 0) {
        $sql = "CREATE TABLE usuarios (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            celular VARCHAR(15),
            senha VARCHAR(100) NOT NULL,
            adm INT(11) NOT NULL
        )";
        if ($conn->query($sql) === TRUE) {
            echo json_encode("Tabela 'usuarios' criada com sucesso.");
        } else {
            echo json_encode("Erro ao criar tabela 'usuarios': " . $conn->error);
        }
    } else {
        //echo json_encode('Tabela usuarios criada com sucesso.');
    }

    // Verificar ou criar tabela chamados
    $sql = "SHOW TABLES LIKE 'chamados'";
    $result = $conn->query($sql);

    if ($result->num_rows == 0) {
        $sql = "CREATE TABLE chamados (
            id INT AUTO_INCREMENT PRIMARY KEY,
            tipo VARCHAR(50) NOT NULL,
            chamado VARCHAR(50) UNIQUE NOT NULL,
            cliente VARCHAR(50) NOT NULL,
            equipamento VARCHAR(100) NOT NULL,
            data DATETIME,
            endereco VARCHAR(100) NOT NULL,
            celular VARCHAR(11) NOT NULL,
            link VARCHAR(150),
            observacao VARCHAR(200),
            tecnico VARCHAR(100) NOT NULL,
            status VARCHAR(50) NOT NULL
        )";
        if ($conn->query($sql) === TRUE) {
            echo json_encode("Tabela 'chamados' criada com sucesso.");
        } else {
            echo json_encode("Erro ao criar tabela 'chamados': " . $conn->error);
        }
    } else {
        echo json_encode("Tabela 'chamados' ja existe.");
    }
}

verificarOuCriarTabelas($conn);
?>