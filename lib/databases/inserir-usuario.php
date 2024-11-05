<?php
include 'db.php';

try {
    $data = json_decode(file_get_contents("php://input"), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido');
    }

    $sql = 'INSERT INTO usuarios (nome, email, celular, senha, adm) VALUES (?, ?, ?, ?, 0)';
    $stmt = $db->prepare($sql);
    if ($stmt->execute([$data['nome'], $data['email'], $data['celular'], $data['senha']])) {
        echo json_encode(['success' => true, 'insertId' => $db->lastInsertId()]);
    } else {
        echo json_encode(['error' => 'Erro ao inserir usuário']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>