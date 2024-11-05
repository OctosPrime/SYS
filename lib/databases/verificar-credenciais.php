<?php
include 'db.php';

try {
    $data = json_decode(file_get_contents("php://input"), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido');
    }

    $sql = 'SELECT * FROM usuarios WHERE email = ? AND senha = ?';
    $stmt = $db->prepare($sql);
    $stmt->execute([$data['email'], $data['senha']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode(['success' => $user ? true : false]);
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>