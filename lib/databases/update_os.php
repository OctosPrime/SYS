<?php
include 'db.php';

header('Content-Type: application/json');

try {
    $db = new PDO($dsn, $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

try {
    $data = json_decode(file_get_contents("php://input"), true);

    $tecnico = $data['tecnico'];
    $chamado = $data['chamado'];
    $cliente = $data['cliente'];
    $equipamento = $data['equipamento'];
    $dataHora = $data['dataHora'];
    $link = $data['link'];
    $observacao = $data['observacao'];
    $status = $data['status'];
    $datafinal = $data['datafinal'];

    $sql = 'INSERT INTO oses (tecnico, chamado, cliente, equipamento, dataHora, link, observacao, status, datafinal) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
    $stmt = $db->prepare($sql);
    $stmt->execute([$tecnico, $chamado, $cliente, $equipamento, $dataHora, $link, $observacao, $status, $datafinal]);

    if ($stmt->rowCount() > 0) {
        echo json_encode(['success' => 'OS updated successfully']);
    } else {
        echo json_encode(['error' => 'Failed to update OS']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
