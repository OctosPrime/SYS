<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$dsn = "mysql:host=sysmedicalapp.mysql.dbaas.com.br;dbname=sysmedicalapp;charset=utf8";
$username = "sysmedicalapp";
$password = "SysMedical123!";

try {
    $db = new PDO($dsn, $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

function checkOrCreateTables($db)
{
    $createUsersTable = "
        CREATE TABLE IF NOT EXISTS usuarios (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            celular VARCHAR(15),
            senha VARCHAR(100) NOT NULL,
            status VARCHAR(50),
            adm INT(11) NOT NULL
        );
    ";

    $createChamadosTable = "
        CREATE TABLE IF NOT EXISTS chamados (
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
        status VARCHAR(50) NOT NULL,
        usuario_id INT(11) NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    );
";

    $db->exec($createUsersTable);
    $db->exec($createChamadosTable);
}

// Call to create tables if not exists
checkOrCreateTables($db);
?>