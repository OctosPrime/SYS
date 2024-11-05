<?php
header("Access-Control-Allow-Origin: *"); // Permite todas as origens. Pode ser mais seguro especificar uma origem específica.
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"); // Métodos permitidos.
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Headers permitidos.

include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Se for uma requisição preflight, retorne imediatamente.
    http_response_code(204); // No Content
    exit;
}

try {
    $data = json_decode(file_get_contents("php://input"), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido');
    }

    $sql = 'INSERT INTO chamados (tipo, chamado, cliente, equipamento, data, endereco, celular, link, observacao, tecnico, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    $stmt = $db->prepare($sql);
    if ($stmt->execute([$data['tipo'], $data['chamado'], $data['cliente'], $data['equipamento'], $data['data'], $data['endereco'], $data['celular'], $data['link'], $data['observacao'], $data['tecnico'], $data['status']])) {
        echo json_encode(['success' => true, 'insertId' => $db->lastInsertId()]);
    } else {
        echo json_encode(['error' => 'Erro ao criar chamado']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>